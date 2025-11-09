import 'package:logger/logger.dart';

/// Logger extensions for PII masking and structured logging
extension SecureLogger on Logger {
  /// Sensitive field keys that should be masked
  static const _sensitiveKeys = {
    'password',
    'token',
    'accessToken',
    'refreshToken',
    'secret',
    'apiKey',
    'creditCard',
    'ssn',
    'authorization',
  };

  /// Mask sensitive data in maps
  Map<String, dynamic> _maskSensitiveData(Map<String, dynamic> data) {
    final masked = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      if (_sensitiveKeys.any((sensitive) => key.contains(sensitive))) {
        masked[entry.key] = '******';
      } else if (entry.value is Map<String, dynamic>) {
        masked[entry.key] = _maskSensitiveData(
          entry.value as Map<String, dynamic>,
        );
      } else if (entry.value is List) {
        masked[entry.key] = _maskList(entry.value as List);
      } else {
        masked[entry.key] = entry.value;
      }
    }
    return masked;
  }

  List<dynamic> _maskList(List<dynamic> list) {
    return list.map(_maskListItem).toList();
  }

  dynamic _maskListItem(dynamic item) {
    if (item is Map<String, dynamic>) {
      return _maskSensitiveData(item);
    }
    return item;
  }

  /// Log with automatic PII masking
  void secureDebug(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final masked = _maskSensitiveData(data);
      d('$message | $masked');
    } else {
      d(message);
    }
  }

  void secureInfo(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final masked = _maskSensitiveData(data);
      i('$message | $masked');
    } else {
      i(message);
    }
  }

  void secureWarning(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final masked = _maskSensitiveData(data);
      w('$message | $masked');
    } else {
      w(message);
    }
  }

  void secureError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    if (data != null) {
      final masked = _maskSensitiveData(data);
      e('$message | $masked', error: error, stackTrace: stackTrace);
    } else {
      e(message, error: error, stackTrace: stackTrace);
    }
  }
}
