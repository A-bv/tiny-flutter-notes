import 'package:field_notes/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('installErrorHandlers registers both global hooks', () {
    installErrorHandlers();

    expect(FlutterError.onError, isNotNull);
    final asyncHandler = PlatformDispatcher.instance.onError;
    expect(asyncHandler, isNotNull);

    // The async hook must report the error as handled (true), so an
    // uncaught async error is logged rather than crashing the app.
    final handled = asyncHandler!(Exception('boom'), StackTrace.current);
    expect(handled, isTrue);
  });
}
