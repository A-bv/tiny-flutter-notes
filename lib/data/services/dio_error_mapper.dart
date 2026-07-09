import 'package:dio/dio.dart';
import 'package:field_notes/data/services/note_api.dart';

/// Translates a dio failure into a user-facing [ApiException].
///
/// Kept separate from the client so the mapping is a single, testable
/// responsibility rather than something duplicated across each verb.
ApiException mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionError:
      return const ApiException('No connection. Check your network.');
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const ApiException('The server took too long to respond.');
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode;
      return ApiException('The server rejected the request ($status).');
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const ApiException('Something went wrong on the server.');
  }
}
