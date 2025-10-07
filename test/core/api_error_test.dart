import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/src/core/networking/api_error.dart';

void main() {
  group('ApiError.fromDioException', () {
    test('maps timeout types to timeout code', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
        message: 'timeout',
      );
      final err = ApiError.fromDioException(ex);
      expect(err.code, 'timeout');
    });

    test('maps connectionError to network_error', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
        message: 'conn',
      );
      final err = ApiError.fromDioException(ex);
      expect(err.code, 'network_error');
    });

    test('maps badResponse 401 to unauthorized', () {
      final response = Response<Object?>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 401,
      );
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: response,
      );
      final err = ApiError.fromDioException(ex);
      expect(err.code, 'unauthorized');
    });

    test('badResponse with no status returns server_error', () {
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
    });

    test('cancel and ssl and unknown map correctly', () {
      final cancel = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.cancel,
      );
      expect(ApiError.fromDioException(cancel).code, 'cancelled');

      final cert = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badCertificate,
        message: 'cert',
      );
      expect(ApiError.fromDioException(cert).code, 'ssl_error');

      final unk = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
        message: 'u',
        error: 'e',
      );
      expect(ApiError.fromDioException(unk).code, 'unknown');
    });

    test('userMessage returns localized message for known codes', () {
      final err = ApiError(message: 'x', code: 'network_error');
      expect(err.userMessage, contains('ネットワークエラー'));
    });
  });
}
