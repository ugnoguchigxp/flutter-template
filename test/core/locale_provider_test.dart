import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/i18n/locale_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocaleNotifier', () {
    test('initial locale is Japanese', () {
      final notifier = LocaleNotifier();
      expect(notifier.state.languageCode, 'ja');
    });

    test('setLocale changes locale', () {
      final notifier = LocaleNotifier();
      expect(notifier.state.languageCode, 'ja');

      notifier.setLocale(const Locale('en'));
      expect(notifier.state.languageCode, 'en');
    });

    test('setLocale can set different locales', () {
      final notifier = LocaleNotifier();

      notifier.setLocale(const Locale('en'));
      expect(notifier.state.languageCode, 'en');

      notifier.setLocale(const Locale('fr'));
      expect(notifier.state.languageCode, 'fr');

      notifier.setLocale(const Locale('ja'));
      expect(notifier.state.languageCode, 'ja');
    });

    test('toggleLocale switches between ja and en', () {
      final notifier = LocaleNotifier();
      expect(notifier.state.languageCode, 'ja');

      notifier.toggleLocale();
      expect(notifier.state.languageCode, 'en');

      notifier.toggleLocale();
      expect(notifier.state.languageCode, 'ja');
    });

    test('toggleLocale works from en to ja', () {
      final notifier = LocaleNotifier();
      notifier.setLocale(const Locale('en'));

      notifier.toggleLocale();
      expect(notifier.state.languageCode, 'ja');
    });

    test('toggleLocale multiple times alternates correctly', () {
      final notifier = LocaleNotifier();

      for (var i = 0; i < 5; i++) {
        notifier.toggleLocale();
        expect(notifier.state.languageCode, i.isEven ? 'en' : 'ja');
      }
    });
  });

  group('localeProvider', () {
    test('provides LocaleNotifier instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final locale = container.read(localeProvider);
      expect(locale, const Locale('ja'));
    });

    test('can update locale through provider', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);
      notifier.setLocale(const Locale('en'));

      final locale = container.read(localeProvider);
      expect(locale, const Locale('en'));
    });

    test('toggleLocale through provider works', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);
      expect(container.read(localeProvider).languageCode, 'ja');

      notifier.toggleLocale();
      expect(container.read(localeProvider).languageCode, 'en');

      notifier.toggleLocale();
      expect(container.read(localeProvider).languageCode, 'ja');
    });
  });
}
