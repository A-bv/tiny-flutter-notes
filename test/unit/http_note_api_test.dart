import 'package:dio/dio.dart';
import 'package:field_notes/data/services/http_note_api.dart';
import 'package:field_notes/domain/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records outgoing requests and answers them from memory, so the client
/// is exercised end to end without a live server (dio's URLProtocolStub).
class _Recorder extends Interceptor {
  final List<RequestOptions> requests = <RequestOptions>[];
  Response<dynamic> Function(RequestOptions options)? onResolve;
  DioException? failure;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requests.add(options);
    final f = failure;
    if (f != null) {
      handler.reject(f);
      return;
    }
    handler.resolve(
      onResolve?.call(options) ??
          Response<dynamic>(requestOptions: options, statusCode: 200),
    );
  }
}

void main() {
  late Dio dio;
  late _Recorder recorder;
  late HttpNoteApi api;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    recorder = _Recorder();
    dio.interceptors.add(recorder);
    api = HttpNoteApi(dio);
  });

  test('upload POSTs the note JSON to /notes', () async {
    final note = Note(
      id: 'a',
      text: 'Buy milk',
      createdAt: DateTime.utc(2026, 7, 9),
      syncStatus: SyncStatus.pending,
    );

    await api.upload(note);

    final request = recorder.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/notes');
    expect(request.data, {
      'id': 'a',
      'text': 'Buy milk',
      'createdAt': '2026-07-09T00:00:00.000Z',
    });
  });
}
