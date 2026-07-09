import 'package:field_notes/ui/note_create/note_create_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The create-note screen: a text field and a Save button.
///
/// It holds only the text being edited; whether the save is running,
/// done, or failed lives in the view model. Reacting to those states
/// (popping on success, showing errors) is wired next.
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
