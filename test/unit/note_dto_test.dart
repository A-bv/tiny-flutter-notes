import 'package:field_notes/data/services/note_dto.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final note = Note(
    id: 'a',
    text: 'Buy milk',
    createdAt: DateTime.utc(2026, 7, 9, 10, 30),
    syncStatus: SyncStatus.pending,
  );

  test('a note serializes to the wire shape', () {
    final json = NoteDto.fromDomain(note).toJson();

    expect(json, {
      'id': 'a',
      'text': 'Buy milk',
      'createdAt': '2026-07-09T10:30:00.000Z',
    });
  });
}
