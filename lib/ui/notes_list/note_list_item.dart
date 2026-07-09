import 'package:field_notes/domain/models/note.dart';
import 'package:flutter/material.dart';

/// A single row in the notes list: the note body, its sync status in
/// words, and a delete button.
///
/// Sync status is shown as text ("Synced" / "Pending sync"), never as
/// colour or an icon alone, so it stays legible to screen readers and
/// the colour-blind.
class NoteListItem extends StatelessWidget {
  /// Creates a list item for [note] with an [onDelete] callback.
  const NoteListItem({required this.note, required this.onDelete, super.key});

  /// The note to display.
  final Note note;

  /// Called when the user taps the delete button.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.text),
      subtitle: Text(_statusLabel),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Delete note',
        onPressed: onDelete,
      ),
    );
  }

  String get _statusLabel =>
      note.syncStatus == SyncStatus.synced ? 'Synced' : 'Pending sync';
}
