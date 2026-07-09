import 'package:field_notes/data/repositories/note_repository.dart';
import 'package:field_notes/data/services/connectivity_service.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/data/services/fake_note_api.dart';
import 'package:field_notes/data/services/note_api.dart';
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

  test('deleteNote drops a never-synced note without the server', () async {
    connectivity.isOnline = false;
    final repo = makeRepository();
    await repo.createNote('Buy milk');
    final note = (await repo.watchNotes().first).single;

    await repo.deleteNote(note);

    expect(await repo.watchNotes().first, isEmpty);
    expect(api.deleted, isEmpty);
  });

  test('deleteNote tombstones a synced note and hides it', () async {
    final repo = makeRepository();
    await repo.createNote('Buy milk');
    await pumpEventQueue(); // uploads, so the note becomes synced
    final synced = (await repo.watchNotes().first).single;
    expect(synced.syncStatus, SyncStatus.synced);

    connectivity.isOnline = false; // observe the tombstone before it flushes
    await repo.deleteNote(synced);

    expect(await repo.watchNotes().first, isEmpty);
    expect(await db.pendingNotes('pendingDeletion'), hasLength(1));
  });

  test('syncPending flushes tombstones to the server and locally', () async {
    final repo = makeRepository();
    await repo.createNote('Buy milk');
    await pumpEventQueue(); // synced and on the server
    final synced = (await repo.watchNotes().first).single;

    connectivity.isOnline = false;
    await repo.deleteNote(synced); // tombstoned
    connectivity.isOnline = true;
    await repo.syncPending();

    expect(api.deleted, [synced.id]);
    expect(await db.allNotes(), isEmpty);
  });

  test('syncPending adopts server notes the device does not have', () async {
    api.remote.add(
      Note(
        id: 'srv',
        text: 'From another device',
        createdAt: DateTime(2026),
        syncStatus: SyncStatus.synced,
      ),
    );
    final repo = makeRepository();

    await repo.syncPending();

    final texts = (await repo.watchNotes().first).map((n) => n.text);
    expect(texts, contains('From another device'));
  });

  test('overlapping sync passes upload a note only once', () async {
    connectivity.isOnline = false;
    final repo = makeRepository();
    await repo.createNote('Buy milk');
    connectivity.isOnline = true;

    await Future.wait([repo.syncPending(), repo.syncPending()]);

    expect(api.uploaded, hasLength(1));
  });

  test('a failed sync is reported on syncErrors', () async {
    connectivity.isOnline = false;
    final repo = makeRepository();
    await repo.createNote('Buy milk');
    api.failure = const ApiException('Server unavailable');
    connectivity.isOnline = true;

    final errors = <String?>[];
    final sub = repo.syncErrors.listen(errors.add);
    await repo.syncPending();
    await sub.cancel();

    expect(errors, contains('Server unavailable'));
  });
}
