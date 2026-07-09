import 'package:field_notes/data/services/note_api.dart';
import 'package:field_notes/domain/models/note.dart';

/// An in-memory [NoteApi] that doubles as the app's zero-setup default
/// and the test double.
///
/// It behaves like a tiny server — [remote] is its store — while also
/// recording every call so tests can assert what the sync worker did and
/// inject failures to drive its error paths.
class FakeNoteApi implements NoteApi {
  /// The notes the "server" currently holds; returned by [fetchAll].
  final List<Note> remote = <Note>[];

  /// Every note passed to [upload], in order (a test audit log).
  final List<Note> uploaded = <Note>[];

  /// Every id passed to [delete], in order (a test audit log).
  final List<String> deleted = <String>[];

  /// When set, every call throws this instead of succeeding.
  ApiException? failure;

  @override
  Future<void> upload(Note note) async {
    _maybeFail();
    uploaded.add(note);
    remote
      ..removeWhere((n) => n.id == note.id)
      ..add(note);
  }

  @override
  Future<void> delete(String id) async {
    _maybeFail();
    deleted.add(id);
    remote.removeWhere((n) => n.id == id);
  }

  @override
  Future<List<Note>> fetchAll() async {
    _maybeFail();
    return List<Note>.of(remote);
  }

  void _maybeFail() {
    final f = failure;
    if (f != null) throw f;
  }
}
