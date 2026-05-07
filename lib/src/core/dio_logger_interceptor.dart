import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class DioLoggerInterceptor extends Interceptor {
  final _logger = Logger('DioRestClient');

  void _logInfo(String text) {
    const magenta = '\x1B[35m';
    const reset = '\x1B[0m';

    final coloredText = text
        .split('\n')
        .map((line) => '$magenta$line$reset')
        .join('\n');

    _logger.log(Level.INFO, coloredText);
  }

  void _logSucces(String text) {
    const green = '\x1B[32m';
    const reset = '\x1B[0m';

    final coloredText = text
        .split('\n')
        .map((line) => '$green$line$reset')
        .join('\n');

    _logger.log(Level.FINEST, coloredText);
  }

  // void _logWarning(String text) {
  //   _logger.log(Level.WARNING, '\x1B[33m$text\x1B[0m');
  // }

  void _logError(String text) {
    const red = '\x1B[31m';
    const reset = '\x1B[0m';

    final coloredText = text
        .split('\n')
        .map((line) => '$red$line$reset')
        .join('\n');

    _logger.log(Level.FINEST, coloredText);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();

    buffer.writeln(
      '=============================================================',
    );

    buffer.writeln('Request ║ ${options.method} ║ ${DateTime.now()}');
    buffer.writeln('${options.uri}\n');

    buffer.writeln('Body:\n');

    if (options.data is Map<String, dynamic>) {
      final data = options.data as Map<String, dynamic>;

      buffer.writeln('{');
      for (final MapEntry(key: key, value: value) in data.entries) {
        if (value is Map) {
          for (final MapEntry(key: key, value: value) in value.entries) {
            buffer.writeln('$key: $value');
          }
        } else {
          buffer.writeln('$key: $value');
        }
      }
    }

    buffer.writeln('}');

    buffer.writeln(
      '=============================================================',
    );

    _logInfo(buffer.toString());
    buffer.clear();

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();

    buffer.writeln(
      '=============================================================',
    );

    final options = err.requestOptions;

    buffer.writeln(
      '${err.runtimeType} ║ '
      '${options.method} ║ '
      '${DateTime.now()}',
    );
    buffer.writeln('${options.uri}\n');

    if (err.response?.data is Map) {
      buffer.writeln('Error:\n');
      final map = err.response?.data as Map<String, dynamic>;

      buffer.writeln('{');
      for (final MapEntry(key: key, value: value) in map.entries) {
        if (value is Map) {
          for (final MapEntry(key: key, value: value) in value.entries) {
            buffer.writeln('$key: $value');
          }
        } else {
          buffer.writeln('$key: $value');
        }
      }
      buffer.writeln('}');
    }

    buffer.writeln(
      '=============================================================',
    );

    _logError(buffer.toString());
    buffer.clear();

    handler.next(err);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final buffer = StringBuffer();

    buffer.writeln(
      '=============================================================',
    );

    final options = response.requestOptions;

    buffer.writeln('Response ║ ${options.method} ║ ${DateTime.now()}');
    buffer.writeln('${options.uri}\n');

    if (response.data is Map) {
      buffer.writeln('Data:\n');
      final map = response.data as Map<String, dynamic>;

      buffer.writeln('{');
      for (final MapEntry(key: key, value: value) in map.entries) {
        if (value is Map) {
          for (final MapEntry(key: key, value: value) in value.entries) {
            buffer.writeln('$key: $value');
          }
        } else {
          buffer.writeln('$key: $value');
        }
      }
      buffer.writeln('}');
    }

    buffer.writeln(
      '=============================================================',
    );

    _logSucces(buffer.toString());
    buffer.clear();

    handler.next(response);
  }
}
