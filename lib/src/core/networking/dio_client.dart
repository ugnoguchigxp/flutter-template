import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../logging/app_logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final logger = ref.watch(appLoggerProvider);
  final options = BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
    responseType: ResponseType.json,
  );

  final dio = Dio(options);

  // Retry interceptor with exponential backoff
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      logPrint: (msg) => logger.d('Retry: $msg'),
      retries: 3,
      retryDelays: const [
        Duration(milliseconds: 500),
        Duration(milliseconds: 1000),
        Duration(milliseconds: 2000),
      ],
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        logger.t('➡️  ${request.method} ${request.uri}');
        handler.next(request);
      },
      onResponse: (response, handler) {
        logger.t('✅  ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        logger.e(
          '❌  ${error.requestOptions.uri} failed',
          error: error,
          stackTrace: error.stackTrace,
        );
        handler.next(error);
      },
    ),
  );

  return dio;
});
