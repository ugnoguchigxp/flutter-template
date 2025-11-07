import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/app/app.dart';
import 'package:flutter_template/src/core/config/app_config.dart';
import 'package:flutter_template/src/core/logging/app_logger.dart';

Future<void> bootstrap() async {
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8081',
  );

  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        AppConfig(
          environment: AppEnvironment.development,
          apiBaseUrl: apiBaseUrl,
        ),
      ),
    ],
    observers: [AppProviderObserver()],
  );

  final logger = container.read(appLoggerProvider);

  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        logger.e(
          'Uncaught Flutter error',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
      platformDispatcher.onError = (error, stackTrace) {
        logger.e(
          'Uncaught platform error',
          error: error,
          stackTrace: stackTrace,
        );
        return true;
      };

      runApp(
        UncontrolledProviderScope(container: container, child: const App()),
      );
    },
    (error, stackTrace) => logger.e(
      'Uncaught zone exception',
      error: error,
      stackTrace: stackTrace,
    ),
  );
}

class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    assert(() {
      debugPrint(
        'Provider: ${provider.name ?? provider.runtimeType}\n'
        'Previous: $previousValue\n'
        'New: $newValue',
      );
      return true;
    }());
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }
}
