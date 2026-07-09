import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_create_viewmodel.g.dart';

/// The view model for the create-note screen.
///
/// Its state is an [AsyncValue] describing the save action, so the view
/// can react to running / done / error without holding any logic itself.
@riverpod
class NoteCreateViewModel extends _$NoteCreateViewModel {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);
}
