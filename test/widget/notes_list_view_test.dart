import 'package:field_notes/data/providers.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/ui/notes_list/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DatabaseService db;

  setUp(() => db = DatabaseService.memory());

  Future<ProviderContainer> pumpList(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseServiceProvider.overrideWith((ref) => db)],
        child: const MaterialApp(home: NotesListView()),
      ),
    );
    final context = tester.element(find.byType(NotesListView));
    return ProviderScope.containerOf(context);
  }

  testWidgets('shows the notes once they load', (tester) async {
    final container = await pumpList(tester);
    await container.read(noteRepositoryProvider).createNote('Buy milk');
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);
  });

  testWidgets('shows an empty-state message when there are no notes', (
    tester,
  ) async {
    await pumpList(tester);
    await tester.pumpAndSettle();

    expect(find.text('No notes yet'), findsOneWidget);
  });
}
