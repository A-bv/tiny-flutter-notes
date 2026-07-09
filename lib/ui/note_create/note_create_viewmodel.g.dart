// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The view model for the create-note screen.
///
/// Its state is an [AsyncValue] describing the save action, so the view
/// can react to running / done / error without holding any logic itself.

@ProviderFor(NoteCreateViewModel)
final noteCreateViewModelProvider = NoteCreateViewModelProvider._();

/// The view model for the create-note screen.
///
/// Its state is an [AsyncValue] describing the save action, so the view
/// can react to running / done / error without holding any logic itself.
final class NoteCreateViewModelProvider
    extends $NotifierProvider<NoteCreateViewModel, AsyncValue<void>> {
  /// The view model for the create-note screen.
  ///
  /// Its state is an [AsyncValue] describing the save action, so the view
  /// can react to running / done / error without holding any logic itself.
  NoteCreateViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteCreateViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteCreateViewModelHash();

  @$internal
  @override
  NoteCreateViewModel create() => NoteCreateViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$noteCreateViewModelHash() =>
    r'00ab02f253d13a4cf633ed412e45c2586dc2aee1';

/// The view model for the create-note screen.
///
/// Its state is an [AsyncValue] describing the save action, so the view
/// can react to running / done / error without holding any logic itself.

abstract class _$NoteCreateViewModel extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
