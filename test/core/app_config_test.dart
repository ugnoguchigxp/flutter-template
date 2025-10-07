import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/src/core/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('AppConfig isProduction true/false', () {
    final prod = AppConfig(
      environment: AppEnvironment.production,
      apiBaseUrl: 'https://api',
    );
    final dev = AppConfig(
      environment: AppEnvironment.development,
      apiBaseUrl: 'https://dev',
    );

    expect(prod.isProduction, isTrue);
    expect(dev.isProduction, isFalse);
  });

  test('appConfigProvider throws when not overridden', () {
    final container = ProviderContainer();
    expect(
      () => container.read(appConfigProvider),
      throwsA(isA<UnimplementedError>()),
    );
  });
}
