import 'package:flutter/material.dart';

// League of Legends official portal palette (Hextech & Piltover Gold / Deep Navy)
// Source: https://www.leagueoflegends.com/
const Color _lolGold = Color(0xffc89b3c); // Hextech Gold / Accent
const Color _lolDarkNavy = Color(0xff091428); // Deep Hextech Navy Blue / Background
const Color _lolOffWhite = Color(0xfff0e6d2); // Off-White / Parchment Light Background

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _lolGold,
      brightness: brightness,
      primary: _lolGold,
      surface: isDark ? _lolDarkNavy : _lolOffWhite,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? _lolDarkNavy : _lolOffWhite,
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}

