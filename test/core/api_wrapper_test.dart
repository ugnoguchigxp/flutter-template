import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
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

  test('get handles DioException', () async {
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
  });

  test('post/put/delete success paths', () async {
    final dio = _dioWithBehavior(
      onRequest: (options, handler) {
        handler.resolve(
          Response(
            requestOptions: options,
            data: {'ok': true},
            statusCode: 200,
          ),
        );
      },
    );
    final wrapper = ApiWrapper(dio: dio, logger: logger);

    final postRes = await wrapper.post<Map<String, dynamic>>('/p');
    expect(postRes.isSuccess, isTrue);
    expect(postRes.dataOrNull, {'ok': true});

    final putRes = await wrapper.put<Map<String, dynamic>>('/u');
    expect(putRes.isSuccess, isTrue);

    final delRes = await wrapper.delete<Map<String, dynamic>>('/d');
    expect(delRes.isSuccess, isTrue);
  });
}
