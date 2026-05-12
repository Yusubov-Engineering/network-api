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
  void register(ModularRegistrar register) {
    // internal
    register.instance<NetworkConfig>(config);
    register.singleton<RestClient>(DioRestClient.new);
    register.singleton<Interceptor>(DioLoggerInterceptor.new);

    // external
    register.singleton<NetworkApi>(NetworkApi.new);
  }
}
