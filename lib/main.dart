import 'dart:async';
import 'dart:developer' as developer;

import 'package:field_notes/ui/core/theme.dart';
import 'package:field_notes/ui/notes_list/notes_list_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Needed before touching platform channels like SystemChrome below.
  WidgetsFlutterBinding.ensureInitialized();
  installErrorHandlers();
  // A single-column phone app: lock it to portrait rather than maintain
  // a landscape layout we do not need.
  unawaited(
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]),
  );
  // ProviderScope stores the state of every provider; wrapping the app
  // in it is what turns Riverpod on.
  runApp(const ProviderScope(child: FieldNotesApp()));
}

/// Installs the two hooks that catch every uncaught error, so none is
/// ever silent.
///
/// `FlutterError.onError` catches errors from the widget layer;
/// `PlatformDispatcher.onError` catches uncaught errors from async code
/// (the modern replacement for `runZonedGuarded`). A production app would
/// forward these to a crash reporter such as Crashlytics or Sentry; here
/// they are logged with a stack trace. Returning `true` from the async
/// hook marks the error handled so it does not crash the app.
void installErrorHandlers() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    developer.log(
      'flutter error',
      name: 'field_notes',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    developer.log(
      'uncaught async error',
      name: 'field_notes',
      error: error,
      stackTrace: stack,
    );
    return true;
  };
}

/// The application root.
///
/// It configures the light and dark themes and shows the first screen,
/// following the device's system brightness.
class FieldNotesApp extends StatelessWidget {
  /// Creates the app.
  const FieldNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const NotesListView(),
    );
  }
}
