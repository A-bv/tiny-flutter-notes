import 'package:alchemist/alchemist.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:field_notes/ui/notes_list/note_list_item.dart';
import 'package:flutter/material.dart';

void main() {
  Note noteWith(SyncStatus status) => Note(
    id: 'a',
    text: 'Buy milk on the way home',
    createdAt: DateTime(2026, 7, 9),
    syncStatus: status,
  );

  goldenTest(
    'NoteListItem renders each sync status',
    fileName: 'note_list_item',
    builder: () => GoldenTestGroup(
      columnWidthBuilder: (_) => const FlexColumnWidth(),
      children: [
        GoldenTestScenario(
          name: 'pending',
          child: SizedBox(
            width: 360,
            child: NoteListItem(note: noteWith(SyncStatus.pending), onDelete: () {}),
          ),
        ),
        GoldenTestScenario(
          name: 'synced',
          child: SizedBox(
            width: 360,
            child: NoteListItem(note: noteWith(SyncStatus.synced), onDelete: () {}),
          ),
        ),
      ],
    ),
  );
}
