import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ja'));

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLocale() {
    state = state.languageCode == 'ja'
        ? const Locale('en')
        : const Locale('ja');
  }
}
