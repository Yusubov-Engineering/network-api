import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'response_body.dart';
import 'rest_client.dart';
import 'rest_exceptions.dart';

abstract class RestClientBase implements RestClient {
  RestClientBase({required String baseUrl}) : baseUri = Uri.parse(baseUrl);

  final Uri baseUri;

  static final _jsonUTF8 = json.fuse(utf8);

  Future<Map<String, dynamic>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });

  @override
  Future<Map<String, dynamic>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(
    path: path,
    method: 'DELETE',
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, dynamic>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(
    path: path,
    method: 'GET',
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, dynamic>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(
    path: path,
    method: 'PATCH',
    body: body,
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, dynamic>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(
    path: path,
    method: 'POST',
    body: body,
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, dynamic>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(
    path: path,
    method: 'PUT',
    body: body,
    headers: headers,
    queryParams: queryParams,
  );

  /// Encodes [body] to JSON and then to UTF8
  @protected
  @visibleForTesting
  List<int> encodeBody(Map<String, dynamic> body) {
    try {
      return _jsonUTF8.encode(body);
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        RestClientException(
          message: 'Error occurred during encoding',
          error: e,
        ),
        stackTrace,
      );
    }
  }

  Uri buildUri(String path, {Map<String, String>? queryParameters}) {
    final finalPath = baseUri.path + path;

    final uri = baseUri.replace(
      path: finalPath,
      queryParameters: {...baseUri.queryParameters, ...?queryParameters},
    );

    return uri;
  }

  /// Decodes the response [body]
  ///
  /// This method decodes the response body to a map and checks if the response
  /// is an error or successful. If the response is an error, it throws a
  ///
  /// If the response is successful, it returns the data from the response.
  ///
  /// If the response is neither an error nor successful, it returns the decoded
  /// body as is.
  @protected
  @visibleForTesting
  Future<Map<String, dynamic>?> decodeResponse(
    ResponseBody<Object>? body, {
    int? statusCode,
  }) async {
    if (body == null) return null;

    final decodedBody = switch (body) {
      MapResponseBody(:final Map<String, Object?> data) => data,
      StringResponseBody(:final String data) => await _decodeString(data),
      BytesResponseBody(:final List<int> data) => await _decodeBytes(data),
    };

    // Return decoded body if it is not an error or data
    return decodedBody;
  }

  /// Decodes a [String] to a [Map<String, Object?>]
  Future<Map<String, dynamic>?> _decodeString(String stringBody) async {
    if (stringBody.isEmpty) return null;

    if (stringBody.length > 1000) {
      return (
            await compute(
              json.decode,
              stringBody,
              debugLabel: kDebugMode ? 'Decode String Compute' : null,
            ),
          )
          as Map<String, Object?>;
    }

    return json.decode(stringBody) as Map<String, Object?>;
  }

  /// Decodes a [List<int>] to a [Map<String, Object?>]
  Future<Map<String, dynamic>?> _decodeBytes(List<int> bytesBody) async {
    if (bytesBody.isEmpty) return null;

    if (bytesBody.length > 1000) {
      return (
            await compute(
              _jsonUTF8.decode,
              bytesBody,
              debugLabel: kDebugMode ? 'Decode Bytes Compute' : null,
            ),
          )
          as Map<String, Object?>;
    }

    return _jsonUTF8.decode(bytesBody)! as Map<String, dynamic>;
  }
}
