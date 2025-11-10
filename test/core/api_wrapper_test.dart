import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_template/src/core/networking/api_error.dart';
import 'package:flutter_template/src/core/networking/api_wrapper.dart';

// Helper to create Dio that resolves or rejects via interceptor
Dio _dioWithBehavior({
  required void Function(RequestOptions, RequestInterceptorHandler) onRequest,
}) {
  final dio = Dio();
  dio.interceptors.clear();
  dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return dio;
}

void main() {
  final logger = Logger();

  group('ApiWrapper GET', () {
    test('get success without parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.resolve(
            Response(requestOptions: options, data: 'ok', statusCode: 200),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.get<String>('/test');
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, 'ok');
    });

    test('get success with parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.resolve(
            Response<Object?>(
              requestOptions: options,
              data: {'v': 1},
              statusCode: 200,
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.get<int>(
        '/test',
        parser: (d) => (d as Map)['v'] as int,
      );
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, 1);
    });

    test('get with query parameters', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          expect(options.queryParameters, {'page': 1, 'limit': 10});
          handler.resolve(
            Response(requestOptions: options, data: [], statusCode: 200),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.get<List>(
        '/test',
        queryParameters: {'page': 1, 'limit': 10},
      );
      expect(res.isSuccess, isTrue);
    });

    test('get handles DioException with connection error', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              message: 'conn',
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.get<Object>('/err');
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'network_error');
    });

    test('get handles DioException with timeout', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.receiveTimeout,
              message: 'timeout',
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.get<Object>('/timeout');
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'timeout');
    });

    test('get handles DioException with 404', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 404,
                data: {'error': 'Not found'},
              ),
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.get<Object>('/notfound');
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'not_found');
    });

    test('get handles unexpected exception', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          throw Exception('boom');
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.get<Object>('/boom');
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'unknown');
      expect(res.errorOrNull?.message, contains('Unknown error'));
    });
  });

  group('ApiWrapper POST', () {
    test('post success without parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          expect(options.data, {'name': 'test'});
          handler.resolve(
            Response(requestOptions: options, data: {'id': 1}, statusCode: 201),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.post<Map<String, dynamic>>(
        '/test',
        data: {'name': 'test'},
      );
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, {'id': 1});
    });

    test('post success with parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.resolve(
            Response<Object?>(
              requestOptions: options,
              data: {
                'user': {'id': 1, 'name': 'John'},
              },
              statusCode: 201,
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.post<String>(
        '/test',
        data: {'name': 'John'},
        parser: (d) => (d as Map)['user']['name'] as String,
      );
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, 'John');
    });

    test('post handles DioException', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 400,
                data: {'error': 'Bad request'},
              ),
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.post<Object>('/test', data: {});
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'validation_error');
    });

    test('post handles unexpected exception', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          throw ArgumentError('Invalid data');
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.post<Object>('/test', data: {});
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'unknown');
    });
  });

  group('ApiWrapper PUT', () {
    test('put success without parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          expect(options.data, {'name': 'updated'});
          handler.resolve(
            Response(
              requestOptions: options,
              data: {'id': 1, 'name': 'updated'},
              statusCode: 200,
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.put<Map<String, dynamic>>(
        '/test/1',
        data: {'name': 'updated'},
      );
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, {'id': 1, 'name': 'updated'});
    });

    test('put success with parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.resolve(
            Response<Object?>(
              requestOptions: options,
              data: {'updated': true, 'version': 2},
              statusCode: 200,
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.put<int>(
        '/test/1',
        data: {'version': 2},
        parser: (d) => (d as Map)['version'] as int,
      );
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, 2);
    });

    test('put handles DioException', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 404,
                data: {'error': 'Not found'},
              ),
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.put<Object>('/test/1', data: {});
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'not_found');
    });
  });

  group('ApiWrapper DELETE', () {
    test('delete success without parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              data: {'deleted': true},
              statusCode: 200,
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.delete<Map<String, dynamic>>('/test/1');
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, {'deleted': true});
    });

    test('delete success with parser', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.resolve(
            Response<Object?>(
              requestOptions: options,
              data: {'status': 'deleted', 'count': 1},
              statusCode: 200,
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.delete<String>(
        '/test/1',
        parser: (d) => (d as Map)['status'] as String,
      );
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull, 'deleted');
    });

    test('delete handles DioException', () async {
      final dio = _dioWithBehavior(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 404,
                data: {'error': 'Not found'},
              ),
            ),
          );
        },
      );
      final wrapper = ApiWrapper(dio: dio, logger: logger);

      final res = await wrapper.delete<Object>('/test/1');
      expect(res.isFailure, isTrue);
      expect(res.errorOrNull?.code, 'not_found');
    });
  });

  group('ApiResult', () {
    test('ApiSuccess properties and methods', () {
      final result = ApiResult.success('test data');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 'test data');
      expect(result.errorOrNull, isNull);
    });

    test('ApiFailure properties and methods', () {
      final error = ApiError(message: 'Test error', code: 'test');
      final result = ApiResult.failure(error);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, error);
    });

    test('ApiResult.when - success case', () {
      final result = ApiResult.success('test');
      final output = result.when(
        success: (data) => 'Success: $data',
        failure: (error) => 'Failure: ${error.message}',
      );
      expect(output, 'Success: test');
    });

    test('ApiResult.when - failure case', () {
      final error = ApiError(message: 'Test error', code: 'test');
      final result = ApiResult.failure(error);
      final output = result.when(
        success: (data) => 'Success: $data',
        failure: (error) => 'Failure: ${error.message}',
      );
      expect(output, 'Failure: Test error');
    });

    test('ApiResult.whenSuccess - success case', () {
      final result = ApiResult.success('test');
      var callbackCalled = false;
      var callbackData = '';

      result.whenSuccess((data) {
        callbackCalled = true;
        callbackData = data;
      });

      expect(callbackCalled, isTrue);
      expect(callbackData, 'test');
    });

    test('ApiResult.whenSuccess - failure case', () {
      final error = ApiError(message: 'Test error', code: 'test');
      final result = ApiResult.failure(error);
      var callbackCalled = false;

      result.whenSuccess((data) {
        callbackCalled = true;
      });

      expect(callbackCalled, isFalse);
    });

    test('ApiResult.whenFailure - success case', () {
      final result = ApiResult.success('test');
      var callbackCalled = false;

      result.whenFailure((error) {
        callbackCalled = true;
      });

      expect(callbackCalled, isFalse);
    });

    test('ApiResult.whenFailure - failure case', () {
      final error = ApiError(message: 'Test error', code: 'test');
      final result = ApiResult.failure(error);
      var callbackCalled = false;
      var callbackError = '';

      result.whenFailure((error) {
        callbackCalled = true;
        callbackError = error.message;
      });

      expect(callbackCalled, isTrue);
      expect(callbackError, 'Test error');
    });

    test('ApiResult equality', () {
      final result1 = ApiResult.success('test');
      final result2 = ApiResult.success('test');
      final result3 = ApiResult.failure(
        ApiError(message: 'error', code: 'test'),
      );

      // ApiResult classes don't implement equals/hashCode, so test value access instead
      expect(result1.dataOrNull, equals(result2.dataOrNull));
      expect(result1.isSuccess, result2.isSuccess);
      expect(result1.isSuccess, isNot(result3.isSuccess));
    });

    test('ApiResult with different data types', () {
      final stringResult = ApiResult.success('string');
      final intResult = ApiResult.success(42);
      final listResult = ApiResult.success([1, 2, 3]);

      expect(stringResult.dataOrNull, isA<String>());
      expect(intResult.dataOrNull, isA<int>());
      expect(listResult.dataOrNull, isA<List>());
    });
  });
}
