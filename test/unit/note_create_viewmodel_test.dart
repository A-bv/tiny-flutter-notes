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
}
