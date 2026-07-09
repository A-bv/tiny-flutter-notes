import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database_service.g.dart';

/// One row per note as stored on the device.
///
/// The stored shape is deliberately flat and string-typed for the sync
/// status so the schema never has to migrate when a new status is
/// added — the mapping to the domain enum lives in the repository.
class LocalNotes extends Table {
  /// The note's stable id (a UUID), also the primary key.
  TextColumn get id => text()();

  /// The note body.
  TextColumn get body => text()();

  /// Creation time, used to sort newest first.
  DateTimeColumn get createdAt => dateTime()();

  /// The sync status name (`pending`, `synced`, `pendingDeletion`).
  TextColumn get syncStatus => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The on-device database and the app's source of truth for notes.
///
/// Exposes hand-written query methods rather than generated DAOs so the
/// repository reads like plain Dart. Tests use [DatabaseService.memory]
/// for a fast, isolated database with nothing on disk.
@DriftDatabase(tables: [LocalNotes])
class DatabaseService extends _$DatabaseService {
  /// Opens the real on-device database.
  DatabaseService() : super(_open());

  /// Opens a throwaway in-memory database for tests.
  DatabaseService.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  /// Streams every stored note as raw rows, newest first; the
  /// repository maps them to the shared domain `Note`.
  Stream<List<LocalNote>> watchNotes() {
    return (select(localNotes)
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .watch();
  }

  /// Inserts [note], or replaces the existing row with the same id.
  ///
  /// One method for both create and update keeps the repository simple:
  /// it never has to ask whether a note already exists.
  Future<void> upsert(LocalNotesCompanion note) =>
      into(localNotes).insertOnConflictUpdate(note);
}

QueryExecutor _open() => driftDatabase(name: 'field_notes');
