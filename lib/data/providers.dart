import 'package:dio/dio.dart';
import 'package:field_notes/data/repositories/note_repository.dart';
import 'package:field_notes/data/services/connectivity_service.dart';
import 'package:field_notes/data/services/database_service.dart';
import 'package:field_notes/data/services/fake_note_api.dart';
import 'package:field_notes/data/services/http_note_api.dart';
import 'package:field_notes/data/services/note_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// This file is the app's dependency-injection graph, the Flutter
/// equivalent of an iOS DI container. Each provider builds one object and
/// declares what it depends on. Tests swap any node with `overrides:` to
/// inject fakes or failures.

/// Provides the on-device database and closes it on shutdown.
@Riverpod(keepAlive: true)
DatabaseService databaseService(Ref ref) {
  final database = DatabaseService();
  ref.onDispose(database.close);
  return database;
}

/// Base URL of a real notes server, injected at build time:
/// `flutter run --dart-define=API_URL=https://your-server`. Empty (the
/// default) keeps the in-memory fake, so the app runs anywhere with zero
/// setup.
const String _apiUrl = String.fromEnvironment('API_URL');

/// Provides the notes API. Nothing above this provider knows which
/// implementation it got — that is the point of the [NoteApi] seam.
@Riverpod(keepAlive: true)
NoteApi noteApi(Ref ref) {
  if (_apiUrl.isNotEmpty) {
    final dio = Dio(
      BaseOptions(
        // The analyzer const-folds the dart-define to its '' default and
        // flags this as redundant; at runtime it is the real URL.
        // ignore: avoid_redundant_argument_values
        baseUrl: _apiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    ref.onDispose(dio.close);
    return HttpNoteApi(dio);
  }
  return FakeNoteApi();
}

/// Provides the connectivity signal and disposes it on shutdown.
@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
}

/// Provides the repository, wiring the three services together.
@Riverpod(keepAlive: true)
NoteRepository noteRepository(Ref ref) {
  final repository = NoteRepository(
    database: ref.watch(databaseServiceProvider),
    api: ref.watch(noteApiProvider),
    connectivity: ref.watch(connectivityServiceProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

/// Streams connectivity changes, starting with the current value, so the
/// list screen can show an offline banner.
@riverpod
Stream<bool> connectivityStatus(Ref ref) async* {
  final service = ref.watch(connectivityServiceProvider);
  yield service.isOnline;
  yield* service.onStatusChange;
}
