import 'package:flutter/material.dart';

/// The app's Material 3 theme, seeded from one brand colour.
///
/// Every colour in the app derives from this seed, so light and dark
/// modes — and their contrast — come for free and stay coherent. No
/// colour is ever hard-coded in a widget.
abstract final class AppTheme {
  // A field-notebook green: warm, calm, and distinct from the default blue.
  static const Color _seed = Color(0xFF356859);

  /// The light theme.
  static ThemeData light() => _themeFor(Brightness.light);

  /// The dark theme.
  static ThemeData dark() => _themeFor(Brightness.dark);

  static ThemeData _themeFor(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
