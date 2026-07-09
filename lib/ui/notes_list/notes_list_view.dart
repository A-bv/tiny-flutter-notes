import 'package:field_notes/domain/models/note.dart';
import 'package:field_notes/ui/note_create/note_create_view.dart';
import 'package:field_notes/ui/notes_list/note_list_item.dart';
import 'package:field_notes/ui/notes_list/notes_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The notes list screen: the app's home.
///
/// It watches the list view model and renders one state at a time —
/// loading, data (the list or an empty message), and, next, error.
class NotesListView extends ConsumerWidget {
  /// Creates the list screen.
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesListViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New note',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const NoteCreateView()),
            ),
          ),
        ],
      ),
      body: switch (notes) {
        AsyncData(:final value) => _NotesBody(
          notes: value,
          onDelete: (note) =>
              ref.read(notesListViewModelProvider.notifier).delete(note),
        ),
        AsyncError() => const _ErrorState(),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          "Something went wrong loading your notes. They're safe on this "
          'device — pull to refresh or reopen the app.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _NotesBody extends StatelessWidget {
  const _NotesBody({required this.notes, required this.onDelete});

  final List<Note> notes;
  final void Function(Note note) onDelete;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(child: Text('No notes yet'));
    }
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteListItem(note: note, onDelete: () => onDelete(note));
      },
    );
  }
}
