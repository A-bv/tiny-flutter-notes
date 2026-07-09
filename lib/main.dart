import 'package:flutter/material.dart';

void main() => runApp(const FieldNotesApp());

/// The application root.
///
/// Intentionally bare for now: the real screens are grown test-first
/// and wired in here at the end. Keeping this minimal means the very
/// first commits carry no untested UI.
class FieldNotesApp extends StatelessWidget {
  /// Creates the app.
  const FieldNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Field Notes',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SizedBox.shrink()),
    );
  }
}
