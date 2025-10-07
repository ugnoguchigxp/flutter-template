import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/config/app_config.dart';
import 'package:flutter_template/src/core/networking/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dioProvider', () {
    test('constructs Dio with proper baseUrl and interceptors', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://api.test',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.options.baseUrl, 'https://api.test');
      expect(dio.interceptors.isNotEmpty, isTrue);
    });

    test('Dio has correct timeout settings', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://api.test',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);

      expect(dio.options.connectTimeout, const Duration(seconds: 10));
      expect(dio.options.receiveTimeout, const Duration(seconds: 10));
    });

    test('Dio has correct content type and response type', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://api.test',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);

      expect(dio.options.contentType, 'application/json');
      expect(dio.options.responseType, ResponseType.json);
    });

    test('Dio has retry interceptor configured', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://api.test',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);

      expect(
        dio.interceptors.any((i) => i.runtimeType.toString().contains('Retry')),
        isTrue,
      );
    });

    test('uses baseUrl from appConfig', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.production,
              apiBaseUrl: 'https://prod-api.example.com',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);

      expect(dio.options.baseUrl, 'https://prod-api.example.com');
    });

    test('multiple reads return same Dio instance', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://api.test',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final dio1 = container.read(dioProvider);
      final dio2 = container.read(dioProvider);

      expect(identical(dio1, dio2), isTrue);
    });
  });
}
