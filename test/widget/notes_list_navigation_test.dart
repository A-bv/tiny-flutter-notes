import 'package:field_notes/data/providers.dart';
import 'package:field_notes/data/services/connectivity_service.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/ui/note_create/note_create_view.dart';
import 'package:field_notes/ui/notes_list/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the New note action opens the create screen', (tester) async {
    final db = DatabaseService.memory();
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWith((ref) => db),
            connectivityServiceProvider.overrideWith(
              (ref) => ConnectivityService(online: false),
            ),
          ],
          child: const MaterialApp(home: NotesListView()),
        ),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(NotesListView)),
      );
      await container.read(noteRepositoryProvider).watchNotes().first;
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('New note'));
      await tester.pumpAndSettle();

      expect(find.byType(NoteCreateView), findsOneWidget);

      container.dispose();
      await db.close();
    });
  });
}
