import 'package:field_notes/domain/models/note.dart';
import 'package:flutter/material.dart';

/// A single row in the notes list: the note body, its sync status, and a
/// delete button, laid out on a rounded card.
///
/// Sync status is shown as a labelled pill ("Synced" / "Pending sync"),
/// with text alongside the colour and icon — never colour alone — so it
/// stays legible to screen readers and the colour-blind.
class NoteListItem extends StatelessWidget {
  /// Creates a list item for [note] with an [onDelete] callback.
  const NoteListItem({required this.note, required this.onDelete, super.key});

  /// The note to display.
  final Note note;

  /// Called when the user taps the delete button.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: const Icon(Icons.sticky_note_2_outlined),
        ),
        title: Text(note.text),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _StatusPill(status: note.syncStatus),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete note',
          onPressed: onDelete,
        ),
      ),
    );
  }
}

/// A small coloured pill showing a note's sync status in words.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final synced = status == SyncStatus.synced;
    final label = synced ? 'Synced' : 'Pending sync';
    final background = synced
        ? scheme.secondaryContainer
        : scheme.tertiaryContainer;
    final foreground = synced
        ? scheme.onSecondaryContainer
        : scheme.onTertiaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            synced ? Icons.cloud_done_outlined : Icons.sync,
            size: 13,
            color: foreground,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
