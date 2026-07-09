import 'package:field_notes/domain/models/note.dart';
import 'package:field_notes/ui/notes_list/notes_list_view.dart';
import 'package:field_notes/ui/notes_list/notes_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A view model whose stream fails, to drive the list's error state.
class _FailingViewModel extends NotesListViewModel {
  @override
  Stream<List<Note>> build() => Stream<List<Note>>.error(Exception('boom'));
}

void main() {
  testWidgets('shows an error message instead of a stuck spinner', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notesListViewModelProvider.overrideWith(_FailingViewModel.new),
        ],
        child: const MaterialApp(home: NotesListView()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Something went wrong'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
