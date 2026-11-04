import 'package:flutter/material.dart';

const Color _seedColor = Color(0xff0a8f8f);

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _seedColor,
      brightness: brightness,
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
