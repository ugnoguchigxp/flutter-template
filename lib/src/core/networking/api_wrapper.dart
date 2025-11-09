import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../logging/app_logger.dart';
import '../logging/logger_extensions.dart';
import 'api_error.dart';
import 'dio_client.dart';

/// React Query-like API wrapper with automatic error handling
class ApiWrapper {
  ApiWrapper({required Dio dio, required Logger logger})
    : _dio = dio,
      _logger = logger;

  final Dio _dio;
  final Logger _logger;

  /// GET request with error handling
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? data)? parser,
    Map<String, dynamic>? logData,
  }) async {
    try {
      _logger.secureDebug('API GET: $path', logData);

      final response = await _dio.get<Object>(
        path,
        queryParameters: queryParameters,
      );

      final data = parser != null ? parser(response.data) : response.data as T;

      _logger.secureInfo('API GET success: $path');
      return ApiResult.success(data);
    } on DioException catch (e, stack) {
      final error = ApiError.fromDioException(e);
      _logger.secureError('API GET failed: $path', error: e, stackTrace: stack);
      return ApiResult.failure(error);
    } catch (e, stack) {
      final error = ApiError(
        message: 'Unexpected error: $e',
        code: 'unknown',
        stackTrace: stack,
      );
      _logger.secureError(
        'API GET unexpected error: $path',
        error: e,
        stackTrace: stack,
      );
      return ApiResult.failure(error);
    }
  }

  /// POST request with error handling
  Future<ApiResult<T>> post<T>(
    String path, {
    Object? data,
    T Function(Object? data)? parser,
    Map<String, dynamic>? logData,
  }) async {
    try {
      _logger.secureDebug('API POST: $path', logData);

      final response = await _dio.post<Object>(path, data: data);

      final result = parser != null
          ? parser(response.data)
          : response.data as T;

      _logger.secureInfo('API POST success: $path');
      return ApiResult.success(result);
    } on DioException catch (e, stack) {
      final error = ApiError.fromDioException(e);
      _logger.secureError(
        'API POST failed: $path',
        error: e,
        stackTrace: stack,
      );
      return ApiResult.failure(error);
    } catch (e, stack) {
      final error = ApiError(
        message: 'Unexpected error: $e',
        code: 'unknown',
        stackTrace: stack,
      );
      _logger.secureError(
        'API POST unexpected error: $path',
        error: e,
        stackTrace: stack,
      );
      return ApiResult.failure(error);
    }
  }

  /// PUT request with error handling
  Future<ApiResult<T>> put<T>(
    String path, {
    Object? data,
    T Function(Object? data)? parser,
    Map<String, dynamic>? logData,
  }) async {
    try {
      _logger.secureDebug('API PUT: $path', logData);

      final response = await _dio.put<Object>(path, data: data);

      final result = parser != null
          ? parser(response.data)
          : response.data as T;

      _logger.secureInfo('API PUT success: $path');
      return ApiResult.success(result);
    } on DioException catch (e, stack) {
      final error = ApiError.fromDioException(e);
      _logger.secureError('API PUT failed: $path', error: e, stackTrace: stack);
      return ApiResult.failure(error);
    } catch (e, stack) {
      final error = ApiError(
        message: 'Unexpected error: $e',
        code: 'unknown',
        stackTrace: stack,
      );
      _logger.secureError(
        'API PUT unexpected error: $path',
        error: e,
        stackTrace: stack,
      );
      return ApiResult.failure(error);
    }
  }

  /// DELETE request with error handling
  Future<ApiResult<T>> delete<T>(
    String path, {
    T Function(Object? data)? parser,
    Map<String, dynamic>? logData,
  }) async {
    try {
      _logger.secureDebug('API DELETE: $path', logData);

      final response = await _dio.delete<Object>(path);

      final result = parser != null
          ? parser(response.data)
          : response.data as T;

      _logger.secureInfo('API DELETE success: $path');
      return ApiResult.success(result);
    } on DioException catch (e, stack) {
      final error = ApiError.fromDioException(e);
      _logger.secureError(
        'API DELETE failed: $path',
        error: e,
        stackTrace: stack,
      );
      return ApiResult.failure(error);
    } catch (e, stack) {
      final error = ApiError(
        message: 'Unexpected error: $e',
        code: 'unknown',
        stackTrace: stack,
      );
      _logger.secureError(
        'API DELETE unexpected error: $path',
        error: e,
        stackTrace: stack,
      );
      return ApiResult.failure(error);
    }
  }
}

/// API result wrapper (Success or Failure)
sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = ApiSuccess<T>;
  const factory ApiResult.failure(ApiError error) = ApiFailure<T>;

  /// Execute callbacks based on result
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiError error) failure,
  }) {
    return switch (this) {
      ApiSuccess(:final data) => success(data),
      ApiFailure(:final error) => failure(error),
    };
  }

  /// Execute callbacks only on success
  void whenSuccess(void Function(T data) callback) {
    if (this is ApiSuccess<T>) {
      callback((this as ApiSuccess<T>).data);
    }
  }

  /// Execute callbacks only on failure
  void whenFailure(void Function(ApiError error) callback) {
    if (this is ApiFailure<T>) {
      callback((this as ApiFailure<T>).error);
    }
  }

  /// Get data or null
  T? get dataOrNull {
    return switch (this) {
      ApiSuccess(:final data) => data,
      ApiFailure() => null,
    };
  }

  /// Get error or null
  ApiError? get errorOrNull {
    return switch (this) {
      ApiSuccess() => null,
      ApiFailure(:final error) => error,
    };
  }

  /// Check if success
  bool get isSuccess => this is ApiSuccess<T>;

  /// Check if failure
  bool get isFailure => this is ApiFailure<T>;
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.error);
  final ApiError error;
}

/// Provider for ApiWrapper
final apiWrapperProvider = Provider<ApiWrapper>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(appLoggerProvider);
  return ApiWrapper(dio: dio, logger: logger);
});
