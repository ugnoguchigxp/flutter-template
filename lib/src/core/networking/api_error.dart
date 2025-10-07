import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';

/// Unified API error model
@freezed
class ApiError with _$ApiError {
  const ApiError._();

  const factory ApiError({
    required String message,
    required String code,
    Object? details,
    StackTrace? stackTrace,
  }) = _ApiError;

  /// User-friendly error message
  String get userMessage {
    switch (code) {
      case 'network_error':
        return 'ネットワークエラーが発生しました。接続を確認してください。';
      case 'timeout':
        return 'タイムアウトしました。もう一度お試しください。';
      case 'unauthorized':
        return '認証エラーです。再度ログインしてください。';
      case 'forbidden':
        return 'アクセス権限がありません。';
      case 'not_found':
        return 'リソースが見つかりません。';
      case 'validation_error':
        return '入力内容を確認してください。';
      case 'server_error':
        return 'サーバーエラーが発生しました。しばらく待ってから再度お試しください。';
      default:
        return message;
    }
  }

  /// Create ApiError from DioException
  factory ApiError.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Request timeout',
          code: 'timeout',
          details: exception.message,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        if (statusCode == null) {
          return ApiError(
            message: 'Bad response with no status code',
            code: 'server_error',
            details: exception.response?.data,
            stackTrace: exception.stackTrace,
          );
        }

        return _fromStatusCode(statusCode, exception);

      case DioExceptionType.cancel:
        return ApiError(
          message: 'Request cancelled',
          code: 'cancelled',
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.connectionError:
        return ApiError(
          message: 'Connection error',
          code: 'network_error',
          details: exception.message,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.badCertificate:
        return ApiError(
          message: 'SSL certificate error',
          code: 'ssl_error',
          details: exception.message,
          stackTrace: exception.stackTrace,
        );

      case DioExceptionType.unknown:
        return ApiError(
          message: exception.message ?? 'Unknown error',
          code: 'unknown',
          details: exception.error,
          stackTrace: exception.stackTrace,
        );
    }
  }

  static ApiError _fromStatusCode(int statusCode, DioException exception) {
    final data = exception.response?.data;

    if (statusCode >= 400 && statusCode < 500) {
      return _fromClientError(statusCode, data, exception.stackTrace);
    } else if (statusCode >= 500) {
      return ApiError(
        message: 'Server error: $statusCode',
        code: 'server_error',
        details: data,
        stackTrace: exception.stackTrace,
      );
    }

    return ApiError(
      message: 'HTTP error: $statusCode',
      code: 'http_error_$statusCode',
      details: data,
      stackTrace: exception.stackTrace,
    );
  }

  static ApiError _fromClientError(
    int statusCode,
    Object? data,
    StackTrace? stackTrace,
  ) {
    switch (statusCode) {
      case 400:
        return ApiError(
          message: 'Validation error',
          code: 'validation_error',
          details: data,
          stackTrace: stackTrace,
        );
      case 401:
        return ApiError(
          message: 'Unauthorized',
          code: 'unauthorized',
          details: data,
          stackTrace: stackTrace,
        );
      case 403:
        return ApiError(
          message: 'Forbidden',
          code: 'forbidden',
          details: data,
          stackTrace: stackTrace,
        );
      case 404:
        return ApiError(
          message: 'Not found',
          code: 'not_found',
          details: data,
          stackTrace: stackTrace,
        );
      case 422:
        return ApiError(
          message: 'Unprocessable entity',
          code: 'validation_error',
          details: data,
          stackTrace: stackTrace,
        );
      case 429:
        return ApiError(
          message: 'Too many requests',
          code: 'rate_limit',
          details: data,
          stackTrace: stackTrace,
        );
      default:
        return ApiError(
          message: 'Client error: $statusCode',
          code: 'client_error_$statusCode',
          details: data,
          stackTrace: stackTrace,
        );
    }
  }
}
