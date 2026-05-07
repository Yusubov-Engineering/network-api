import 'dart:io';

import 'package:dio/dio.dart';

import '../network_config.dart';
import 'response_body.dart';
import 'rest_client_base.dart';
import 'rest_exceptions.dart';

final class DioRestClient extends RestClientBase {
  DioRestClient(NetworkConfig config, Interceptor loggerInterceptor, {Dio? dio})
    : _dio = (dio ?? Dio())
        ..options = BaseOptions(
          baseUrl: config.baseUrl,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      super(baseUrl: config.baseUrl) {
    // Attach the interceptor immediately!
    _dio.interceptors.add(loggerInterceptor);
  }

  final Dio _dio;
  Dio get dio => _dio;

  void add(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  @override
  Future<Map<String, dynamic>> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        queryParameters: queryParams,
        options: Options(method: method, headers: headers),
      );

      final result = await decodeResponse(
        MapResponseBody(response.data! as Map<String, dynamic>),
        statusCode: response.statusCode,
      );

      if (result!['data'] is Map<String, dynamic>) {
        final data = result['data'] as Map<String, dynamic>;
        final message = data['message'] as String?;
        data.remove('message');

        return {
          'statusCode': response.statusCode,
          'data': data,
          'message': message,
        };
      } else if (result['data'] is List) {
        final rawList = result['data'] as List<dynamic>;
        final data = rawList
            .map((item) => item as Map<String, dynamic>)
            .toList();

        return {'statusCode': response.statusCode, 'data': data};
      }

      return result;
    } on DioException catch (e, s) {
      /// parse error as json
      if (e.response != null) {
        final responseBody = e.response!.data as Map<String, dynamic>;
        throw RequestException.fromJson(responseBody);
      } else {
        Error.throwWithStackTrace(
          RestClientException(
            message: 'RestClientException from Dio Request',
            error: e,
          ),
          s,
        );
      }
    } on SocketException catch (err, stackTrace) {
      Error.throwWithStackTrace(NoInternetException(), stackTrace);
    } catch (e, s) {
      Error.throwWithStackTrace(
        UnknownRestClientException(
          message: 'RestClientException from Dio Request',
          error: e,
        ),
        s,
      );
    }
  }
}
