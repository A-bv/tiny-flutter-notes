import 'package:field_notes/data/providers.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_list_viewmodel.g.dart';

/// The view model for the notes list screen.
///
/// It exposes the notes as an [AsyncValue] by forwarding the repository's
/// stream. Because it is a stream, the list rebuilds by itself whenever a
/// note is added or synced, so the view never fetches or refreshes by
/// hand.
@riverpod
class NotesListViewModel extends _$NotesListViewModel {
  @override
  Stream<List<Note>> build() {
    return ref.watch(noteRepositoryProvider).watchNotes();
  }
}
