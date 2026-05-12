import 'package:dependency_injection_api/dependency_injection_api.dart';
import 'package:dio/dio.dart';

import 'network_api_provider.dart';
import 'core/rest_client.dart';
import 'core/dio_logger_interceptor.dart';
import 'core/dio_rest_client.dart';
import 'network_config.dart';

class NetworkApiModule implements AppModule {
  // The app must provide this configuration
  NetworkApiModule({required this.config});

  final NetworkConfig config;

  @override
  void register(ModularInjector injector) {
    // internal
    injector.instance<NetworkConfig>(config);
    injector.singleton<RestClient>(DioRestClient.new);
    injector.singleton<Interceptor>(DioLoggerInterceptor.new);

    // external
    injector.singleton<NetworkApi>(NetworkApi.new);
  }
}
