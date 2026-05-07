import 'package:dependency_injection_api/dependency_injection_api.dart';
import 'package:dio/dio.dart';

import 'network_api_provider.dart';
import 'core/rest_client.dart';
import 'core/dio_logger_interceptor.dart';
import 'core/dio_rest_client.dart';
import 'network_config.dart';

class NetworkApiModule extends AppModule {
  // The app must provide this configuration
  NetworkApiModule({required this.config});

  final NetworkConfig config;

  @override
  void register(ModuleRegistry registry) {
    // internal
    registry.registerInstance<NetworkConfig>(config);
    registry.registerSingleton<RestClient>(() => DioRestClient.new);
    registry.registerSingleton<Interceptor>(() => DioLoggerInterceptor.new);

    // external
    registry.registerSingleton<NetworkApi>(() => NetworkApi.new);
  }
}
