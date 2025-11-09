import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/src/core/i18n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalizations', () {
    test('load and translate en.json keys', () async {
      final localizations = AppLocalizations(const Locale('en'));
      await localizations.load();

      expect(localizations.translate('app.title'), 'Nimbus Control');
      expect(
        localizations.translate('dashboard.revenue_trend'),
        'Revenue Trend',
      );
      expect(localizations.translate('api_demo.methods.get'), 'GET');
    });

    test('unknown key returns the key itself', () async {
      final localizations = AppLocalizations(const Locale('en'));
      await localizations.load();

      expect(localizations.translate('not.exists.key'), 'not.exists.key');
      expect(localizations.translate('another.missing'), 'another.missing');
    });

    test('load and translate ja.json keys', () async {
      final localizations = AppLocalizations(const Locale('ja'));
      await localizations.load();

      expect(localizations.translate('app.title'), 'Nimbus Control');
      expect(localizations.translate('dashboard.revenue_trend'), '収益トレンド');
    });

    test('handles nested keys correctly', () async {
      final localizations = AppLocalizations(const Locale('en'));
      await localizations.load();

      expect(localizations.translate('api_demo.methods.get'), 'GET');
      expect(localizations.translate('api_demo.methods.post'), 'POST');
    });

    test('handles missing nested keys', () async {
      final localizations = AppLocalizations(const Locale('en'));
      await localizations.load();

      expect(
        localizations.translate('api_demo.missing.nested'),
        'api_demo.missing.nested',
      );
    });

    test('locale is stored correctly', () {
      final enLocalizations = AppLocalizations(const Locale('en'));
      expect(enLocalizations.locale.languageCode, 'en');

      final jaLocalizations = AppLocalizations(const Locale('ja'));
      expect(jaLocalizations.locale.languageCode, 'ja');
    });

    test('supportedLocales contains en and ja', () {
      expect(AppLocalizations.supportedLocales.length, 2);
      expect(
        AppLocalizations.supportedLocales.any((l) => l.languageCode == 'en'),
        isTrue,
      );
      expect(
        AppLocalizations.supportedLocales.any((l) => l.languageCode == 'ja'),
        isTrue,
      );
    });
  });

  group('_AppLocalizationsDelegate', () {
    const delegate = AppLocalizations.delegate;

    test('isSupported returns true for en and ja', () {
      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('ja')), isTrue);
    });

    test('isSupported returns false for unsupported locales', () {
      expect(delegate.isSupported(const Locale('fr')), isFalse);
      expect(delegate.isSupported(const Locale('de')), isFalse);
      expect(delegate.isSupported(const Locale('zh')), isFalse);
    });

    test('load creates AppLocalizations instance', () async {
      final localizations = await delegate.load(const Locale('en'));
      expect(localizations, isA<AppLocalizations>());
      expect(localizations.locale.languageCode, 'en');
    });

    test('shouldReload returns false', () {
      expect(delegate.shouldReload(delegate), isFalse);
    });
  });

  group('LocalizationExtension', () {
    testWidgets('tr extension method works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [AppLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final title = context.tr('app.title');
                return Text(title);
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Nimbus Control'), findsOneWidget);
    });
  });
}
