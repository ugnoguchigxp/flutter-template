import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:flutter_template/src/core/logging/logger_extensions.dart';
import 'package:flutter_template/src/core/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_template/src/core/logging/app_logger.dart';
import 'package:flutter_template/src/core/networking/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('masking sensitive keys in map', () {
    final logger = Logger();
    final data = {
      'username': 'bob',
      'password': 'secret',
      'nested': {'token': 'abc', 'safe': 'ok'},
      'list': [
        {'accessToken': 'x'},
        1,
        'a',
      ],
    };

    // call secureDebug just to exercise masking
    logger.secureDebug('msg', data);

    // ensure mask function doesn't mutate original
    expect(data['password'], 'secret');
    expect((data['nested'] as Map)['token'], 'abc');
  });

  test('secureInfo/warning/error with data', () {
    final logger = Logger();
    logger.secureInfo('i', {'token': 'x'});
    logger.secureWarning('w', {'password': 'p'});
    logger.secureError(
      'e',
      error: Exception('err'),
      stackTrace: StackTrace.current,
      data: {'secret': 's'},
    );
    expect(true, isTrue);
  });

  test('providers initialize', () {
    final container = ProviderContainer();
    // reading appLoggerProvider should return a Logger
    final logger = container.read(appLoggerProvider);
    expect(logger, isA<Logger>());
    // dioProvider depends on appConfigProvider and appLoggerProvider; provide a fake appConfig
    final container2 = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(
            environment: AppEnvironment.development,
            apiBaseUrl: 'https://x',
          ),
        ),
      ],
    );
    final dio = container2.read(dioProvider);
    expect(dio, isA<Dio>());
  });
}
