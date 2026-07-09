import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:uuid/uuid.dart';

/// The single source of truth for notes and the offline-first brain of
/// the app.
///
/// The UI only ever watches [watchNotes]; the local database is the
/// source of truth. Collaborators (a note API, connectivity) are added
/// to this class as the syncing behaviour that needs them is built.
class NoteRepository {
  /// Creates the repository over the on-device [database].
  NoteRepository({required DatabaseService database}) : _db = database;

  final DatabaseService _db;
  final Uuid _uuid = const Uuid();

  /// Streams all notes, newest first, mapped from database rows to the
  /// shared domain [Note]. The UI subscribes to this and nothing else.
  Stream<List<Note>> watchNotes() =>
      _db.watchNotes().map((rows) => rows.map(_toDomain).toList());

  /// Creates a note from [text] and stores it locally as `pending`, so
  /// the list updates instantly. Uploading happens later, once the
  /// syncing behaviour is built.
  Future<void> createNote(String text) async {
    final note = Note(
      // A UUID, not a timestamp: two notes created in the same
      // microsecond would otherwise share an id and overwrite each other.
      id: _uuid.v4(),
      text: text.trim(),
      createdAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await _db.upsert(_toCompanion(note));
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
