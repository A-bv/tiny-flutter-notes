import 'package:field_notes/domain/models/note.dart';
import 'package:field_notes/ui/notes_list/note_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Note noteWith(SyncStatus status) => Note(
    id: 'a',
    text: 'Buy milk',
    createdAt: DateTime(2026, 7, 9),
    syncStatus: status,
  );

  Future<void> pumpItem(WidgetTester tester, Note note) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: NoteListItem(note: note, onDelete: () {})),
    ),
  );

  testWidgets('renders the note text', (tester) async {
    await pumpItem(tester, noteWith(SyncStatus.synced));
    expect(find.text('Buy milk'), findsOneWidget);
  });

  testWidgets('shows sync status as words, not colour alone', (tester) async {
    await pumpItem(tester, noteWith(SyncStatus.pending));
    expect(find.text('Pending sync'), findsOneWidget);

    await pumpItem(tester, noteWith(SyncStatus.synced));
    expect(find.text('Synced'), findsOneWidget);
  });
}
