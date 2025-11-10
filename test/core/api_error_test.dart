import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/src/core/networking/api_error.dart';

void main() {
  group('ApiError', () {
    group('constructor', () {
      test('creates ApiError with required fields', () {
        final error = ApiError(
          message: 'Test error',
          code: 'test_code',
          details: {'key': 'value'},
          stackTrace: StackTrace.current,
        );

        expect(error.message, 'Test error');
        expect(error.code, 'test_code');
        expect(error.details, {'key': 'value'});
        expect(error.stackTrace, isNotNull);
      });

      test('creates ApiError with minimal fields', () {
        final error = ApiError(message: 'Test', code: 'test');

        expect(error.message, 'Test');
        expect(error.code, 'test');
        expect(error.details, isNull);
        expect(error.stackTrace, isNull);
      });

      test('equality works correctly', () {
        final error1 = ApiError(message: 'Test', code: 'test');
        final error2 = ApiError(message: 'Test', code: 'test');
        final error3 = ApiError(message: 'Different', code: 'test');

        expect(error1, equals(error2));
        expect(error1, isNot(equals(error3)));
      });

      test('copyWith works correctly', () {
        final original = ApiError(
          message: 'Original',
          code: 'original',
          details: 'original_details',
        );
        final updated = original.copyWith(message: 'Updated');

        expect(updated.message, 'Updated');
        expect(updated.code, 'original');
        expect(updated.details, 'original_details');
      });
    });

    group('userMessage', () {
      test('returns localized message for network_error', () {
        final error = ApiError(message: 'Network error', code: 'network_error');
        expect(error.userMessage, 'ネットワークエラーが発生しました。接続を確認してください。');
      });

      test('returns localized message for timeout', () {
        final error = ApiError(message: 'Timeout', code: 'timeout');
        expect(error.userMessage, 'タイムアウトしました。もう一度お試しください。');
      });

      test('returns localized message for unauthorized', () {
        final error = ApiError(message: 'Unauthorized', code: 'unauthorized');
        expect(error.userMessage, '認証エラーです。再度ログインしてください。');
      });

      test('returns localized message for forbidden', () {
        final error = ApiError(message: 'Forbidden', code: 'forbidden');
        expect(error.userMessage, 'アクセス権限がありません。');
      });

      test('returns localized message for not_found', () {
        final error = ApiError(message: 'Not found', code: 'not_found');
        expect(error.userMessage, 'リソースが見つかりません。');
      });

      test('returns localized message for validation_error', () {
        final error = ApiError(message: 'Validation error', code: 'validation_error');
        expect(error.userMessage, '入力内容を確認してください。');
      });

      test('returns localized message for server_error', () {
        final error = ApiError(message: 'Server error', code: 'server_error');
        expect(error.userMessage, 'サーバーエラーが発生しました。しばらく待ってから再度お試しください。');
      });

      test('returns original message for unknown codes', () {
        final error = ApiError(message: 'Unknown error', code: 'unknown_code');
        expect(error.userMessage, 'Unknown error');
      });

      test('returns original message for empty code', () {
        final error = ApiError(message: 'Some error', code: '');
        expect(error.userMessage, 'Some error');
      });
    });

    group('fromDioException', () {
      group('timeout types', () {
        test('maps connectionTimeout to timeout code', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timeout',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'timeout');
          expect(err.message, 'Request timeout');
          expect(err.details, 'Connection timeout');
        });

        test('maps sendTimeout to timeout code', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.sendTimeout,
            message: 'Send timeout',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'timeout');
          expect(err.message, 'Request timeout');
        });

        test('maps receiveTimeout to timeout code', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.receiveTimeout,
            message: 'Receive timeout',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'timeout');
          expect(err.message, 'Request timeout');
        });
      });

      group('connection errors', () {
        test('maps connectionError to network_error', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.connectionError,
            message: 'Connection failed',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'network_error');
          expect(err.message, 'Connection error');
          expect(err.details, 'Connection failed');
        });

        test('maps badCertificate to ssl_error', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badCertificate,
            message: 'Certificate invalid',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'ssl_error');
          expect(err.message, 'SSL certificate error');
          expect(err.details, 'Certificate invalid');
        });
      });

      group('client errors (4xx)', () {
        test('maps 400 to validation_error', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 400,
            data: {'error': 'Invalid input'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'validation_error');
          expect(err.message, 'Validation error');
          expect(err.details, {'error': 'Invalid input'});
        });

        test('maps 401 to unauthorized', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 401,
            data: {'error': 'Unauthorized'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'unauthorized');
          expect(err.message, 'Unauthorized');
        });

        test('maps 403 to forbidden', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 403,
            data: {'error': 'Access denied'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'forbidden');
          expect(err.message, 'Forbidden');
        });

        test('maps 404 to not_found', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 404,
            data: {'error': 'Resource not found'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'not_found');
          expect(err.message, 'Not found');
        });

        test('maps 422 to validation_error', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 422,
            data: {'error': 'Unprocessable entity'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'validation_error');
          expect(err.message, 'Unprocessable entity');
        });

        test('maps 429 to rate_limit', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 429,
            data: {'error': 'Too many requests'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'rate_limit');
          expect(err.message, 'Too many requests');
        });

        test('maps other 4xx to client_error_XXX', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 418,
            data: {'error': "I'm a teapot"},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'client_error_418');
          expect(err.message, 'Client error: 418');
        });
      });

      group('server errors (5xx)', () {
        test('maps 500 to server_error', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 500,
            data: {'error': 'Internal server error'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'server_error');
          expect(err.message, 'Server error: 500');
          expect(err.details, {'error': 'Internal server error'});
        });

        test('maps 502 to server_error', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 502,
            data: {'error': 'Bad gateway'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'server_error');
          expect(err.message, 'Server error: 502');
        });

        test('maps 503 to server_error', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 503,
            data: {'error': 'Service unavailable'},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'server_error');
          expect(err.message, 'Server error: 503');
        });
      });

      group('other HTTP errors', () {
        test('maps 200 to http_error_200', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 200,
            data: {'success': true},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'http_error_200');
          expect(err.message, 'HTTP error: 200');
        });

        test('maps 302 to http_error_302', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 302,
            data: {'redirect': true},
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'http_error_302');
          expect(err.message, 'HTTP error: 302');
        });
      });

      group('special cases', () {
        test('maps cancel to cancelled', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.cancel,
            message: 'Request cancelled',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'cancelled');
          expect(err.message, 'Request cancelled');
        });

        test('maps unknown to unknown with message', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.unknown,
            message: 'Something went wrong',
            error: 'Detailed error',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'unknown');
          expect(err.message, 'Something went wrong');
          expect(err.details, 'Detailed error');
        });

        test('maps unknown to unknown with default message', () {
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.unknown,
            error: 'Detailed error',
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'unknown');
          expect(err.message, 'Unknown error');
          expect(err.details, 'Detailed error');
        });

        test('handles badResponse with no status code', () {
          final response = Response<Object?>(
            requestOptions: RequestOptions(path: '/'),
          );
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.badResponse,
            response: response,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.code, 'server_error');
          expect(err.message, 'Bad response with no status code');
        });

        test('preserves stack trace from DioException', () {
          final stackTrace = StackTrace.current;
          final ex = DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.connectionError,
            stackTrace: stackTrace,
          );
          final err = ApiError.fromDioException(ex);
          expect(err.stackTrace, stackTrace);
        });
      });
    });

    group('toString', () {
      test('returns string representation', () {
        final error = ApiError(
          message: 'Test error',
          code: 'test_code',
          details: {'key': 'value'},
        );
        final str = error.toString();
        expect(str, contains('ApiError'));
        expect(str, contains('Test error'));
        expect(str, contains('test_code'));
      });
    });
  });
}
