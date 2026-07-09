import 'package:field_notes/data/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DatabaseService db;

  setUp(() => db = DatabaseService.memory());
  tearDown(() => db.close());

  test('a fresh database watches an empty list', () async {
    expect(await db.watchNotes().first, isEmpty);
  });
}
