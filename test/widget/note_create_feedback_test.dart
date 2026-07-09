import 'package:field_notes/ui/note_create/note_create_view.dart';
import 'package:field_notes/ui/note_create/note_create_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _SucceedingViewModel extends NoteCreateViewModel {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  @override
  Future<void> save(String text) async {
    state = const AsyncLoading<void>();
    state = const AsyncData<void>(null);
  }
}

class _FailingViewModel extends NoteCreateViewModel {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  @override
  Future<void> save(String text) async {
    state = const AsyncLoading<void>();
    state = AsyncError<void>(Exception('boom'), StackTrace.current);
  }
}

Widget _app(NoteCreateViewModel Function() vm, {Widget? home}) => ProviderScope(
  overrides: [noteCreateViewModelProvider.overrideWith(vm)],
  child: MaterialApp(home: home ?? const NoteCreateView()),
);

void main() {
  testWidgets('pops when the save succeeds', (tester) async {
    await tester.pumpWidget(
      _app(
        _SucceedingViewModel.new,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const NoteCreateView(),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(NoteCreateView), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(NoteCreateView), findsNothing);
  });

  testWidgets('shows a message when the save fails', (tester) async {
    await tester.pumpWidget(_app(_FailingViewModel.new));

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining("Couldn't save"), findsOneWidget);
  });
}
