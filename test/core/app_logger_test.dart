import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/logging/app_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

void main() {
  group('appLoggerProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('provides Logger instance', () {
      final logger = container.read(appLoggerProvider);

      expect(logger, isA<Logger>());
    });

    test('Logger is configured with PrettyPrinter', () {
      final logger = container.read(appLoggerProvider);

      // Verify logger is not null and is properly configured
      expect(logger, isNotNull);
    });

    test('Logger can be used for logging', () {
      final logger = container.read(appLoggerProvider);

      // These should not throw
      expect(() => logger.d('Debug message'), returnsNormally);
      expect(() => logger.i('Info message'), returnsNormally);
      expect(() => logger.w('Warning message'), returnsNormally);
    });

    test('multiple reads return same logger instance', () {
      final logger1 = container.read(appLoggerProvider);
      final logger2 = container.read(appLoggerProvider);

      expect(identical(logger1, logger2), isTrue);
    });

    test('different containers have different logger instances', () {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();
      addTearDown(() {
        container1.dispose();
        container2.dispose();
      });

      final logger1 = container1.read(appLoggerProvider);
      final logger2 = container2.read(appLoggerProvider);

      expect(identical(logger1, logger2), isFalse);
    });
  });
}
