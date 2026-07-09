import 'package:field_notes/data/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DatabaseService db;

  setUp(() => db = DatabaseService.memory());
  tearDown(() => db.close());

  LocalNotesCompanion row(
    String id, {
    String body = 'x',
    String status = 'pending',
    DateTime? at,
  }) => LocalNotesCompanion.insert(
    id: id,
    body: body,
    createdAt: at ?? DateTime(2026),
    syncStatus: status,
  );

  test('a fresh database watches an empty list', () async {
    expect(await db.watchNotes().first, isEmpty);
  });

  test('upsert inserts a note, then updates the same id in place', () async {
    await db.upsert(row('a', body: 'first'));
    expect((await db.watchNotes().first).single.body, 'first');

    await db.upsert(row('a', body: 'second'));
    final rows = await db.watchNotes().first;
    expect(rows, hasLength(1));
    expect(rows.single.body, 'second');
  });

  test('watchNotes returns notes newest first', () async {
    await db.upsert(row('old', at: DateTime(2026)));
    await db.upsert(row('new', at: DateTime(2026, 6)));

    final ids = (await db.watchNotes().first).map((r) => r.id).toList();
    expect(ids, ['new', 'old']);
  });

  test('deleteById removes only the matching note', () async {
    await db.upsert(row('a'));
    await db.upsert(row('b'));

    await db.deleteById('a');

    final ids = (await db.watchNotes().first).map((r) => r.id).toList();
    expect(ids, ['b']);
  });

  test('pendingNotes filters by status; allNotes returns every row', () async {
    await db.upsert(row('a')); // defaults to pending
    await db.upsert(row('b', status: 'synced'));

    final pending = (await db.pendingNotes('pending')).map((r) => r.id);
    expect(pending, ['a']);

    final all = (await db.allNotes()).map((r) => r.id).toSet();
    expect(all, {'a', 'b'});
  });
}
