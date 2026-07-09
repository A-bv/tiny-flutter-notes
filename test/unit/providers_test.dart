import 'package:field_notes/data/providers.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the provider graph builds a working repository', () async {
    final container = ProviderContainer(
      overrides: [
        // Swap only the database for an in-memory one; everything else
        // (the fake API default, connectivity) resolves for real.
        databaseServiceProvider.overrideWith((ref) => DatabaseService.memory()),
      ],
    );
    addTearDown(container.dispose);

    final repo = container.read(noteRepositoryProvider);
    await repo.createNote('Buy milk');

    final notes = await repo.watchNotes().first;
    expect(notes.single.text, 'Buy milk');
  });
}
