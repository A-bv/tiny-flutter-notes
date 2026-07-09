import 'package:flutter/material.dart';

/// The app's Material 3 theme, seeded from one brand colour.
///
/// Every colour in the app derives from this seed, so light and dark
/// modes — and their contrast — come for free and stay coherent. No
/// colour is ever hard-coded in a widget.
abstract final class AppTheme {
  static const Color _seed = Color(0xFF3B6EA5);

  /// The light theme.
  static ThemeData light() => _themeFor(Brightness.light);

  /// The dark theme.
  static ThemeData dark() => _themeFor(Brightness.dark);

  static ThemeData _themeFor(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
    );
  }
}
