import 'package:dio/dio.dart';
import 'package:field_notes/data/services/note_api.dart';
import 'package:field_notes/data/services/note_dto.dart';
import 'package:field_notes/domain/models/note.dart';

/// A [NoteApi] backed by a real HTTP server, spoken to through dio.
///
/// It is the production implementation behind the NoteApi seam: swap the
/// FakeNoteApi for this by injecting an `API_URL` and nothing above the
/// seam changes. JSON lives entirely here, via [NoteDto].
class HttpNoteApi implements NoteApi {
  /// Creates the client over a configured `dio` instance (base URL and
  /// timeouts are set by the caller).
  HttpNoteApi(this._dio);

  final Dio _dio;

  @override
  Future<void> upload(Note note) async {
    await _dio.post<void>('/notes', data: NoteDto.fromDomain(note).toJson());
  }

  @override
  Future<void> delete(String id) async {
    await _dio.delete<void>('/notes/$id');
  }

  @override
  Future<List<Note>> fetchAll() async {
    final response = await _dio.get<List<dynamic>>('/notes');
    final notes = <Note>[];
    for (final item in response.data ?? <dynamic>[]) {
      try {
        notes.add(NoteDto.fromJson(item as Map<String, dynamic>).toDomain());
      } on Object {
        // One malformed record must not sink the batch: skip it and keep
        // adopting the rest. The record is simply ignored.
        continue;
      }
    }
    return notes;
  }
}
