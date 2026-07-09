import 'package:field_notes/ui/note_create/note_create_view.dart';
import 'package:field_notes/ui/note_create/note_create_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records the text passed to save, without touching the repository.
class _RecordingViewModel extends NoteCreateViewModel {
  final List<String> saved = <String>[];

  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  @override
  Future<void> save(String text) async => saved.add(text);
}

void main() {
  testWidgets('typing and tapping Save calls save with the text', (
    tester,
  ) async {
    final vm = _RecordingViewModel();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [noteCreateViewModelProvider.overrideWith(() => vm)],
        child: const MaterialApp(home: NoteCreateView()),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(vm.saved, ['Buy milk']);
  });
}
