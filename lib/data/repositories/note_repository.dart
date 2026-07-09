import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/data/services/note_api.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:uuid/uuid.dart';

/// The single source of truth for notes and the offline-first brain of
/// the app.
///
/// The UI only ever watches [watchNotes]; the local database is the
/// source of truth. Collaborators (connectivity) are added to this class
/// as the syncing behaviour that needs them is built.
class NoteRepository {
  /// Creates the repository over the on-device [database] and [api].
  NoteRepository({required DatabaseService database, required NoteApi api})
    : _db = database,
      _api = api;

  final DatabaseService _db;
  final NoteApi _api;
  final Uuid _uuid = const Uuid();

  /// Streams all notes, newest first, mapped from database rows to the
  /// shared domain [Note]. The UI subscribes to this and nothing else.
  Stream<List<Note>> watchNotes() =>
      _db.watchNotes().map((rows) => rows.map(_toDomain).toList());

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
  }

  /// Runs one sync pass: uploads every pending note, then marks each
  /// synced locally once the server has it.
  Future<void> syncPending() async {
    final toUpload = await _db.pendingNotes(SyncStatus.pending.name);
    for (final row in toUpload) {
      final note = _toDomain(row);
      await _api.upload(note);
      await _db.upsert(
        _toCompanion(note.copyWith(syncStatus: SyncStatus.synced)),
      );
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
