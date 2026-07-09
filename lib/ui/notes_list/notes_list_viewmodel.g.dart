// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The view model for the notes list screen.
///
/// It exposes the notes as an [AsyncValue] by forwarding the repository's
/// stream. Because it is a stream, the list rebuilds by itself whenever a
/// note is added or synced, so the view never fetches or refreshes by
/// hand.

@ProviderFor(NotesListViewModel)
final notesListViewModelProvider = NotesListViewModelProvider._();

/// The view model for the notes list screen.
///
/// It exposes the notes as an [AsyncValue] by forwarding the repository's
/// stream. Because it is a stream, the list rebuilds by itself whenever a
/// note is added or synced, so the view never fetches or refreshes by
/// hand.
final class NotesListViewModelProvider
    extends $StreamNotifierProvider<NotesListViewModel, List<Note>> {
  /// The view model for the notes list screen.
  ///
  /// It exposes the notes as an [AsyncValue] by forwarding the repository's
  /// stream. Because it is a stream, the list rebuilds by itself whenever a
  /// note is added or synced, so the view never fetches or refreshes by
  /// hand.
  NotesListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesListViewModelHash();

  @$internal
  @override
  NotesListViewModel create() => NotesListViewModel();
}

String _$notesListViewModelHash() =>
    r'737ded50ea828dd63ff6d0adfe94e3556f92e12e';

/// The view model for the notes list screen.
///
/// It exposes the notes as an [AsyncValue] by forwarding the repository's
/// stream. Because it is a stream, the list rebuilds by itself whenever a
/// note is added or synced, so the view never fetches or refreshes by
/// hand.

abstract class _$NotesListViewModel extends $StreamNotifier<List<Note>> {
  Stream<List<Note>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Note>>, List<Note>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Note>>, List<Note>>,
              AsyncValue<List<Note>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
