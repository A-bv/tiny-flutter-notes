import 'package:field_notes/data/providers.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/ui/note_create/note_create_viewmodel.dart';
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

  test('starts idle in the data state', () {
    final container = makeContainer();

    final state = container.read(noteCreateViewModelProvider);

    expect(state, isA<AsyncData<void>>());
  });

  test('save stores the note and settles to data', () async {
    final container = makeContainer();

    await container.read(noteCreateViewModelProvider.notifier).save('Buy milk');

    expect(container.read(noteCreateViewModelProvider), isA<AsyncData<void>>());
    final repo = container.read(noteRepositoryProvider);
    final notes = await repo.watchNotes().first;
    expect(notes.single.text, 'Buy milk');
  });

  test('a blank save settles to AsyncError', () async {
    final container = makeContainer();

    await container.read(noteCreateViewModelProvider.notifier).save('   ');

    expect(container.read(noteCreateViewModelProvider), isA<AsyncError<void>>());
  });

  test('ignores a save while one is already running', () async {
    final container = makeContainer();
    final vm = container.read(noteCreateViewModelProvider.notifier);

    await Future.wait([vm.save('first'), vm.save('second')]);

    final repo = container.read(noteRepositoryProvider);
    expect(await repo.watchNotes().first, hasLength(1));
  });
}
