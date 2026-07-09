import 'package:field_notes/data/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_create_viewmodel.g.dart';

/// The view model for the create-note screen.
///
/// Its state is an [AsyncValue] describing the save action, so the view
/// can react to running / done / error without holding any logic itself.
/// On success the note is saved locally at once; syncing to the server
/// happens in the background (see `NoteRepository`).
@riverpod
class NoteCreateViewModel extends _$NoteCreateViewModel {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  /// Saves a note with the given [text].
  ///
  /// Goes to loading, asks the repository to store the note, then settles
  /// to data (success) or error. `AsyncValue.guard` turns a thrown error
  /// into an [AsyncError] so there is no try/catch to get wrong.
  Future<void> save(String text) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(
      () => ref.read(noteRepositoryProvider).createNote(text),
    );
  }
}
