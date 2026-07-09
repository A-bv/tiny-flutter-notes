import 'dart:async';

import 'package:field_notes/ui/note_create/note_create_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The create-note screen: a text field and a Save button.
///
/// It holds only the text being edited; whether the save is running,
/// done, or failed lives in the view model. The screen reacts to those
/// states: it pops back to the list on success and shows a message on
/// failure.
class NoteCreateView extends ConsumerStatefulWidget {
  /// Creates the screen.
  const NoteCreateView({super.key});

  @override
  ConsumerState<NoteCreateView> createState() => _NoteCreateViewState();
}

class _NoteCreateViewState extends ConsumerState<NoteCreateView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() =>
      ref.read(noteCreateViewModelProvider.notifier).save(_controller.text);

  @override
  Widget build(BuildContext context) {
    // React to the save action's outcome: pop when a run finishes cleanly,
    // warn when it fails. Listening (not watching) keeps this a one-time
    // side effect per transition rather than a rebuild.
    ref.listen(noteCreateViewModelProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Couldn't save your note. Please try again."),
          ),
        );
      } else if (previous is AsyncLoading && next is AsyncData) {
        unawaited(Navigator.of(context).maybePop());
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('New note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Write a note…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
