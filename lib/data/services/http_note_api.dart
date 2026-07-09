import 'package:dio/dio.dart';
import 'package:field_notes/data/services/dio_error_mapper.dart';
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
  Future<void> upload(Note note) => _guard(
    () => _dio.post<void>('/notes', data: NoteDto.fromDomain(note).toJson()),
  );

  @override
  Future<void> delete(String id) =>
      _guard(() => _dio.delete<void>('/notes/$id'));

  @override
  Future<List<Note>> fetchAll() => _guard(() async {
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
  });

  /// Runs a dio [call], turning any DioException into a mapped
  /// [ApiException] so the boundary only ever throws typed failures.
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
