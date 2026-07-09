import 'package:field_notes/domain/models/note.dart';

/// A failure the app can explain to the user: offline, a timeout, or a
/// bad response. Carries a ready-to-show [message].
class ApiException implements Exception {
  /// Creates an exception with a user-facing [message].
  const ApiException(this.message);

  /// A short, human-readable description of what went wrong.
  final String message;

  @override
  String toString() => 'ApiException: $message';
}

/// The boundary to a notes backend.
///
/// The repository depends on this interface, never on a concrete client,
/// so a fake, a real HTTP client, or a deliberately failing stub all
/// drop in the same way. Implementations speak in domain [Note]s; JSON
/// stays behind them.
abstract interface class NoteApi {
  /// Uploads [note] to the server, creating or replacing it.
  Future<void> upload(Note note);

  /// Removes the note with the given [id] from the server.
  Future<void> delete(String id);

  /// Returns every note the server currently holds.
  Future<List<Note>> fetchAll();
}
