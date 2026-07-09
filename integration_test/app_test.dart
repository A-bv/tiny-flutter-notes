import 'package:field_notes/data/providers.dart';
import 'package:field_notes/data/services/connectivity_service.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a user creates a note and sees it in the list', (tester) async {
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
          child: const FieldNotesApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No notes yet'), findsOneWidget);

      // Open the create screen, type a note, and save it.
      await tester.tap(find.byTooltip('New note'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Buy milk');
      await tester.tap(find.text('Save'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Back on the list, the note is there and marked pending (offline).
      expect(find.text('Buy milk'), findsOneWidget);
      expect(find.text('Pending sync'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(FieldNotesApp)),
      );
      container.dispose();
      await db.close();
    });
  });
}
