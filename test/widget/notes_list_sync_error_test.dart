import 'package:field_notes/data/providers.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:field_notes/ui/notes_list/notes_list_view.dart';
import 'package:field_notes/ui/notes_list/notes_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// An empty notes list, so the test avoids the database entirely and
/// focuses on the sync-error banner.
class _EmptyListViewModel extends NotesListViewModel {
  @override
  Stream<List<Note>> build() => Stream<List<Note>>.value(const []);
}

void main() {
  testWidgets('shows a banner when a background sync fails', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notesListViewModelProvider.overrideWith(_EmptyListViewModel.new),
          syncErrorProvider.overrideWith(
            (ref) => Stream<String?>.value(
              'The server rejected the request (500).',
            ),
          ),
        ],
        child: const MaterialApp(home: NotesListView()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('server rejected'), findsOneWidget);
  });
}
