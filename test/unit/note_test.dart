import 'package:field_notes/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2026, 7, 9, 10, 30);

  Note makeNote({
    String id = 'a',
    String text = 'Buy milk',
    SyncStatus status = SyncStatus.pending,
  }) => Note(id: id, text: text, createdAt: createdAt, syncStatus: status);

  group('Note equality', () {
    test('two notes with the same fields are equal', () {
      expect(makeNote(), equals(makeNote()));
      expect(makeNote().hashCode, equals(makeNote().hashCode));
    });

    test('notes differing in any field are not equal', () {
      expect(makeNote(), isNot(equals(makeNote(id: 'b'))));
      expect(makeNote(), isNot(equals(makeNote(text: 'Other'))));
      expect(makeNote(), isNot(equals(makeNote(status: SyncStatus.synced))));
    });
  });
}
