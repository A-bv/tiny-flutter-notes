// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This file is the app's dependency-injection graph, the Flutter
/// equivalent of an iOS DI container. Each provider builds one object and
/// declares what it depends on. Tests swap any node with `overrides:` to
/// inject fakes or failures.
/// Provides the on-device database and closes it on shutdown.

@ProviderFor(databaseService)
final databaseServiceProvider = DatabaseServiceProvider._();

/// This file is the app's dependency-injection graph, the Flutter
/// equivalent of an iOS DI container. Each provider builds one object and
/// declares what it depends on. Tests swap any node with `overrides:` to
/// inject fakes or failures.
/// Provides the on-device database and closes it on shutdown.

final class DatabaseServiceProvider
    extends
        $FunctionalProvider<DatabaseService, DatabaseService, DatabaseService>
    with $Provider<DatabaseService> {
  /// This file is the app's dependency-injection graph, the Flutter
  /// equivalent of an iOS DI container. Each provider builds one object and
  /// declares what it depends on. Tests swap any node with `overrides:` to
  /// inject fakes or failures.
  /// Provides the on-device database and closes it on shutdown.
  DatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseServiceHash();

  @$internal
  @override
  $ProviderElement<DatabaseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DatabaseService create(Ref ref) {
    return databaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatabaseService>(value),
    );
  }
}

String _$databaseServiceHash() => r'a2c2263f020197e6ff39871b602290ceaf8e94e2';

/// Provides the notes API. Nothing above this provider knows which
/// implementation it got — that is the point of the [NoteApi] seam.

@ProviderFor(noteApi)
final noteApiProvider = NoteApiProvider._();

/// Provides the notes API. Nothing above this provider knows which
/// implementation it got — that is the point of the [NoteApi] seam.

final class NoteApiProvider
    extends $FunctionalProvider<NoteApi, NoteApi, NoteApi>
    with $Provider<NoteApi> {
  /// Provides the notes API. Nothing above this provider knows which
  /// implementation it got — that is the point of the [NoteApi] seam.
  NoteApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteApiHash();

  @$internal
  @override
  $ProviderElement<NoteApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoteApi create(Ref ref) {
    return noteApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteApi>(value),
    );
  }
}

String _$noteApiHash() => r'1235c63ce0f71cf014b692ee6cbce250eb388875';

/// Provides the connectivity signal and disposes it on shutdown.

@ProviderFor(connectivityService)
final connectivityServiceProvider = ConnectivityServiceProvider._();

/// Provides the connectivity signal and disposes it on shutdown.

final class ConnectivityServiceProvider
    extends
        $FunctionalProvider<
          ConnectivityService,
          ConnectivityService,
          ConnectivityService
        >
    with $Provider<ConnectivityService> {
  /// Provides the connectivity signal and disposes it on shutdown.
  ConnectivityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityServiceHash();

  @$internal
  @override
  $ProviderElement<ConnectivityService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectivityService create(Ref ref) {
    return connectivityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivityService>(value),
    );
  }
}

String _$connectivityServiceHash() =>
    r'8aad782a54ee2cf5a02eced6652ee1a3bb1b3acd';

/// Provides the repository, wiring the three services together.

@ProviderFor(noteRepository)
final noteRepositoryProvider = NoteRepositoryProvider._();

/// Provides the repository, wiring the three services together.

final class NoteRepositoryProvider
    extends $FunctionalProvider<NoteRepository, NoteRepository, NoteRepository>
    with $Provider<NoteRepository> {
  /// Provides the repository, wiring the three services together.
  NoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteRepositoryHash();

  @$internal
  @override
  $ProviderElement<NoteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoteRepository create(Ref ref) {
    return noteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteRepository>(value),
    );
  }
}

String _$noteRepositoryHash() => r'ab5a64f10685fe33b31bb0122526a5d7a7954a3a';

/// Streams connectivity changes, starting with the current value, so the
/// list screen can show an offline banner.

@ProviderFor(connectivityStatus)
final connectivityStatusProvider = ConnectivityStatusProvider._();

/// Streams connectivity changes, starting with the current value, so the
/// list screen can show an offline banner.

final class ConnectivityStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Streams connectivity changes, starting with the current value, so the
  /// list screen can show an offline banner.
  ConnectivityStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityStatusHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return connectivityStatus(ref);
  }
}

String _$connectivityStatusHash() =>
    r'ae144aa7fbbc634eabaffd117abed5ae604d15ed';

/// Streams the latest background-sync error (null when the last sync was
/// fine), so the list screen can warn the user.

@ProviderFor(syncError)
final syncErrorProvider = SyncErrorProvider._();

/// Streams the latest background-sync error (null when the last sync was
/// fine), so the list screen can warn the user.

final class SyncErrorProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  /// Streams the latest background-sync error (null when the last sync was
  /// fine), so the list screen can warn the user.
  SyncErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncErrorHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return syncError(ref);
  }
}

String _$syncErrorHash() => r'bd880513034442e46437510c0ab80dec87070f83';
