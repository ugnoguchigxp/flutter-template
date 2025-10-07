import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_template/src/core/networking/api_wrapper.dart';

// helper
void main() {
  final logger = Logger();

  test('post handles DioException', () async {
    final dio = Dio();
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) => h.reject(
          DioException(
            requestOptions: o,
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: o, statusCode: 500),
          ),
        ),
      ),
    );

    final wrapper = ApiWrapper(dio: dio, logger: logger);
    final res = await wrapper.post<Map<String, dynamic>>('/p');
    expect(res.isFailure, isTrue);
    expect(res.errorOrNull?.code, 'server_error');
  });

  test('put handles 404 as not_found', () async {
    final dio = Dio();
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) => h.reject(
          DioException(
            requestOptions: o,
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: o, statusCode: 404),
          ),
        ),
      ),
    );

    final wrapper = ApiWrapper(dio: dio, logger: logger);
    final res = await wrapper.put<Map<String, dynamic>>('/u');
    expect(res.isFailure, isTrue);
    expect(res.errorOrNull?.code, 'not_found');
  });

  test('delete handles client error 400 as validation_error', () async {
    final dio = Dio();
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) => h.reject(
          DioException(
            requestOptions: o,
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: o, statusCode: 400),
          ),
        ),
      ),
    );

    final wrapper = ApiWrapper(dio: dio, logger: logger);
    final res = await wrapper.delete<Map<String, dynamic>>('/d');
    expect(res.isFailure, isTrue);
    expect(res.errorOrNull?.code, 'validation_error');
  });
}
