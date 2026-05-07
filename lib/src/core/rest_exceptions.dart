class RestClientException implements Exception {
  RestClientException({
    this.message = 'ClientException',
    this.statusCode,
    this.error,
  });

  final String message;
  final int? statusCode;
  final dynamic error;
}

class RequestException implements Exception {
  RequestException({
    this.success = false,
    this.message,
    this.error,
    this.data = const {},
  });

  factory RequestException.fromJson(Map<String, dynamic> json) {
    return RequestException(
      success: json['success'] as bool,
      error: json['error'] as String?,
      message: (json['data'] as Map<String, dynamic>)['message'] as String?,
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );
  }

  final bool success;
  final String? error;
  final String? message;
  final Map<String, dynamic> data;

  @override
  String toString() {
    return '''
RequestException{
    success: $success,
    error: $error, 
    message: $message, 
    data: $data
    }
    ''';
  }
}

class ServerException implements Exception {
  ServerException({
    this.message = 'ServerException',
    this.statusCode,
    this.error,
  });

  final String message;
  final int? statusCode;
  final dynamic error;
}

class UnknownRestClientException implements Exception {
  UnknownRestClientException({this.message = 'ServerException', this.error});

  final String message;
  final dynamic error;

  @override
  String toString() {
    return '''
      UnknownRestClientException {
        message: $message,
        erroer: $error,
      }
      ''';
  }
}

class NoInternetException implements Exception {
  NoInternetException({
    this.message = 'No Internet Connection',
    this.statusCode,
    this.error,
  });

  final String message;
  final int? statusCode;
  final dynamic error;

  @override
  String toString() {
    return '''
      NoInternetException {
        message: $message,
        error: $error,
      }
      ''';
  }
}
