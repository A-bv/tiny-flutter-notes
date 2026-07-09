import 'package:field_notes/data/providers.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/ui/notes_list/notes_list_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        databaseServiceProvider.overrideWith((ref) => DatabaseService.memory()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('exposes the notes stream from the repository', () async {
    final container = makeContainer();
    await container.read(noteRepositoryProvider).createNote('Buy milk');

    // Keep the auto-dispose provider mounted, exactly as a widget would.
    container.listen(notesListViewModelProvider, (_, _) {});
    final notes = await container.read(notesListViewModelProvider.future);

    expect(notes.single.text, 'Buy milk');
  });
}
