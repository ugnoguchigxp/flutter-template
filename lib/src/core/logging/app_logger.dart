import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final appLoggerProvider = Provider<Logger>((ref) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: kDebugMode ? 2 : 0,
      errorMethodCount: 8,
      lineLength: 80,
      printEmojis: false,
      colors: false,
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );
});
