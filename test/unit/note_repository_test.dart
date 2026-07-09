import 'package:field_notes/data/repositories/note_repository.dart';
import 'package:field_notes/data/services/connectivity_service.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/data/services/fake_note_api.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DatabaseService db;
  late FakeNoteApi api;
  late ConnectivityService connectivity;

  setUp(() {
    db = DatabaseService.memory();
    api = FakeNoteApi();
    connectivity = ConnectivityService();
  });
  tearDown(() async {
    connectivity.dispose();
    await db.close();
  });

  NoteRepository makeRepository() =>
      NoteRepository(database: db, api: api, connectivity: connectivity);

  Future<Note> onlyNote() async => (await db.watchNotes().first)
      .map(
        (r) => Note(
          id: r.id,
          text: r.body,
          createdAt: r.createdAt,
          syncStatus: SyncStatus.values.asNameMap()[r.syncStatus]!,
        ),
      )
      .single;

  test('createNote saves a note locally as pending', () async {
    final repo = makeRepository();

    await repo.createNote('Buy milk');

    final notes = await repo.watchNotes().first;
    expect(notes, hasLength(1));
    expect(notes.single.text, 'Buy milk');
    expect(notes.single.syncStatus, SyncStatus.pending);
  });

  test('createNote rejects blank text and stores nothing', () async {
    final repo = makeRepository();

    await expectLater(() => repo.createNote('   '), throwsArgumentError);
    expect(await repo.watchNotes().first, isEmpty);
  });

  test('syncPending uploads pending notes and marks them synced', () async {
    // Start offline so createNote does not auto-trigger a sync; this
    // keeps the test focused on syncPending as a unit.
    connectivity.isOnline = false;
    final repo = makeRepository();
    await repo.createNote('Buy milk');

    connectivity.isOnline = true;
    await repo.syncPending();

    expect(api.uploaded.single.text, 'Buy milk');
    expect((await onlyNote()).syncStatus, SyncStatus.synced);
  });

  test('syncPending does nothing while offline', () async {
    connectivity.isOnline = false;
    final repo = makeRepository();
    await repo.createNote('Buy milk');

    await repo.syncPending();

    expect(api.uploaded, isEmpty);
    expect((await onlyNote()).syncStatus, SyncStatus.pending);
  });

  test('createNote triggers an upload when online', () async {
    final repo = makeRepository();

    await repo.createNote('Buy milk');
    await pumpEventQueue();

    expect(api.uploaded.single.text, 'Buy milk');
  });
}
