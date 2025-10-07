import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/src/core/networking/api_error.dart';

void main() {
  test('client error codes map to expected ApiError codes', () {
    final codes = {
      400: 'validation_error',
      401: 'unauthorized',
      403: 'forbidden',
      404: 'not_found',
      422: 'validation_error',
      429: 'rate_limit',
    };

    for (final entry in codes.entries) {
      final response = Response<Object?>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: entry.key,
      );
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: response,
      );
      final err = ApiError.fromDioException(ex);
      expect(
        err.code,
        entry.value,
        reason: 'status ${entry.key} should map to ${entry.value}',
      );
    }
  });
}
