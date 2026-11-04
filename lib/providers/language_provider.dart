import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('es'));

  Future<void> changeLanguage(String code) async {
    // Language change disabled: app is Spanish-only.
  }
}
