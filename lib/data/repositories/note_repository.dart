import 'dart:async';

import 'package:field_notes/data/services/connectivity_service.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/data/services/note_api.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:uuid/uuid.dart';

/// The single source of truth for notes and the offline-first brain of
/// the app.
///
/// The UI only ever watches [watchNotes]; the local database is the
/// source of truth. Writes save locally first, then sync when the
/// device is online.
class NoteRepository {
  /// Creates the repository over the on-device [database], [api], and
  /// [connectivity] signal.
  NoteRepository({
    required DatabaseService database,
    required NoteApi api,
    required ConnectivityService connectivity,
  }) : _db = database,
       _api = api,
       _connectivity = connectivity;

  final DatabaseService _db;
  final NoteApi _api;
  final ConnectivityService _connectivity;
  final Uuid _uuid = const Uuid();

  /// Streams all notes, newest first, mapped from database rows to the
  /// shared domain [Note]. The UI subscribes to this and nothing else.
  Stream<List<Note>> watchNotes() {
    return _db.watchNotes().map(
      (rows) => rows
          .where((row) => row.syncStatus != SyncStatus.pendingDeletion.name)
          .map(_toDomain)
          .toList(),
    );
  }

  /// Creates a note from [text] and stores it locally as `pending`, so
  /// the list updates instantly. Uploading happens later, once the
  /// syncing behaviour is built.
  Future<void> createNote(String text) async {
    final body = text.trim();
    if (body.isEmpty) {
      throw ArgumentError.value(text, 'text', 'A note cannot be empty');
    }
    final note = Note(
      // A UUID, not a timestamp: two notes created in the same
      // microsecond would otherwise share an id and overwrite each other.
      id: _uuid.v4(),
      text: body,
      createdAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await _db.upsert(_toCompanion(note));
    // Fire-and-forget: the save is done once the note is on the device;
    // the upload happens in the background so the UI never waits on it.
    if (_connectivity.isOnline) unawaited(syncPending());
  }

  /// Deletes [note].
  ///
  /// A note the server never saw (not yet `synced`) is dropped from the
  /// device outright. Deleting a note the server already has is handled
  /// later, once tombstoning is built.
  Future<void> deleteNote(Note note) async {
    if (note.syncStatus == SyncStatus.synced) {
      // Keep the row as a tombstone so the sync worker can tell the
      // server to remove it; hide it from the list right away.
      await _db.upsert(
        _toCompanion(note.copyWith(syncStatus: SyncStatus.pendingDeletion)),
      );
      if (_connectivity.isOnline) unawaited(syncPending());
    } else {
      await _db.deleteById(note.id);
    }
  }

  /// Runs one sync pass: uploads every pending note, then marks each
  /// synced locally once the server has it. Does nothing while offline.
  Future<void> syncPending() async {
    if (!_connectivity.isOnline) return;
    final toUpload = await _db.pendingNotes(SyncStatus.pending.name);
    for (final row in toUpload) {
      final note = _toDomain(row);
      await _api.upload(note);
      await _db.upsert(
        _toCompanion(note.copyWith(syncStatus: SyncStatus.synced)),
      );
    }
    final toDelete = await _db.pendingNotes(SyncStatus.pendingDeletion.name);
    for (final row in toDelete) {
      await _api.delete(row.id);
      await _db.deleteById(row.id);
    }
    // Pull: adopt server notes this device has never seen. Additive on
    // purpose — at last-write-wins scope, deletions made elsewhere do
    // not propagate here (that needs server-side tombstones).
    final known = (await _db.allNotes()).map((row) => row.id).toSet();
    for (final note in await _api.fetchAll()) {
      if (!known.contains(note.id)) {
        await _db.upsert(_toCompanion(note));
      }
    }
  }

  Note _toDomain(LocalNote row) {
    return Note(
      id: row.id,
      text: row.body,
      createdAt: row.createdAt,
      syncStatus:
          SyncStatus.values.asNameMap()[row.syncStatus] ?? SyncStatus.pending,
    );
  }

  LocalNotesCompanion _toCompanion(Note note) {
    return LocalNotesCompanion.insert(
      id: note.id,
      body: note.text,
      createdAt: note.createdAt,
      syncStatus: note.syncStatus.name,
    );
  }
}
