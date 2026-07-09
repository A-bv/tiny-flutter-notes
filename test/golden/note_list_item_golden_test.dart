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

  Widget row(SyncStatus status) => Material(
    child: SizedBox(
      width: 360,
      child: NoteListItem(note: noteWith(status), onDelete: () {}),
    ),
  );

  // goldenTest registers the test and returns a Future the framework
  // awaits internally; there is nothing to await here.
  // ignore: discarded_futures
  goldenTest(
    'NoteListItem renders each sync status',
    fileName: 'note_list_item',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(name: 'pending', child: row(SyncStatus.pending)),
        GoldenTestScenario(name: 'synced', child: row(SyncStatus.synced)),
      ],
    ),
  );
}
