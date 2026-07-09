import 'package:field_notes/ui/core/theme.dart';
import 'package:field_notes/ui/notes_list/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScope stores the state of every provider; wrapping the app
  // in it is what turns Riverpod on.
  runApp(const ProviderScope(child: FieldNotesApp()));
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
