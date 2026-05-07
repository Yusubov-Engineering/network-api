import 'package:dio/dio.dart';

import 'src/core/rest_client.dart';

class NetworkApi {
  const NetworkApi({required this.client, required this.loggerInterceptor});

  final RestClient client;
  final Interceptor loggerInterceptor;
}
