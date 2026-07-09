import 'package:field_notes/data/repositories/note_repository.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DatabaseService db;

  setUp(() => db = DatabaseService.memory());
  tearDown(() => db.close());

  NoteRepository makeRepository() => NoteRepository(database: db);

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
}
