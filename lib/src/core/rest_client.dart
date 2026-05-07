/// {@template rest_client}
/// A REST client for making HTTP requests.
/// {@endtemplate}
abstract class RestClient {
  /// Sends a GET request to the given [path].
  Future<Map<String, dynamic>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  /// Sends a POST request to the given [path].
  Future<Map<String, dynamic>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  /// Sends a PUT request to the given [path].
  Future<Map<String, dynamic>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  /// Sends a DELETE request to the given [path].
  Future<Map<String, dynamic>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  /// Sends a PATCH request to the given [path].
  Future<Map<String, dynamic>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });
}
