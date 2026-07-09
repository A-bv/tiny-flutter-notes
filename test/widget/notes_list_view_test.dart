import 'package:field_notes/data/providers.dart';
import 'package:field_notes/data/services/connectivity_service.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/ui/notes_list/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Drift runs on the real event loop, so every test drives the widget
  // inside runAsync and tears the graph down before it ends, cancelling
  // Drift's stream timers. Connectivity is forced offline so the view
  // tests are not entangled with background syncing.
  Future<void> withList(
    WidgetTester tester,
    Future<void> Function(ProviderContainer container) body,
  ) async {
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
      await body(container);
      container.dispose();
      await db.close();
    });
  }

  testWidgets('shows the notes once they load', (tester) async {
    await withList(tester, (container) async {
      await container.read(noteRepositoryProvider).createNote('Buy milk');
      await container.read(noteRepositoryProvider).watchNotes().first;
      await tester.pump();

      expect(find.text('Buy milk'), findsOneWidget);
    });
  });

  testWidgets('shows an empty-state message when there are no notes', (
    tester,
  ) async {
    await withList(tester, (container) async {
      await container.read(noteRepositoryProvider).watchNotes().first;
      await tester.pump();

      expect(find.text('No notes yet'), findsOneWidget);
    });
  });

  testWidgets('tapping delete removes the note', (tester) async {
    await withList(tester, (container) async {
      await container.read(noteRepositoryProvider).createNote('Buy milk');
      await container.read(noteRepositoryProvider).watchNotes().first;
      await tester.pump();
      expect(find.text('Buy milk'), findsOneWidget);

      await tester.tap(find.byTooltip('Delete note'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();

      expect(find.text('Buy milk'), findsNothing);
    });
  });

  testWidgets('announces an offline banner to screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await withList(tester, (container) async {
      await container.read(noteRepositoryProvider).watchNotes().first;
      await tester.pumpAndSettle();

      final banner = find.text('Offline — changes will sync when reconnected');
      expect(banner, findsOneWidget);
      final node = tester.getSemantics(banner);
      expect(node.flagsCollection.isLiveRegion, isTrue);
    });
    handle.dispose();
  });
}
