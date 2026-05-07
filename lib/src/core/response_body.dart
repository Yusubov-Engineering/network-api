/// {@template response_body}
/// A sealed class representing the response body
/// {@endtemplate}
sealed class ResponseBody<T> {
  /// {@macro response_body}
  const ResponseBody(this.data);

  /// The data of the response.
  final T data;
}

/// {@template string_response_body}
/// A [ResponseBody] for a [String] response
/// {@endtemplate}
class StringResponseBody extends ResponseBody<String> {
  /// {@macro string_response_body}
  const StringResponseBody(super.data);
}

/// {@template map_response_body}
/// A [ResponseBody] for a [Map<String, Object?>] response
/// {@endtemplate}
class MapResponseBody extends ResponseBody<Map<String, dynamic>> {
  /// {@macro map_response_body}
  const MapResponseBody(super.data);
}

/// {@template bytes_response_body}
/// A [ResponseBody] for both Uint8List and [List<int>] responses
/// {@endtemplate}
class BytesResponseBody extends ResponseBody<List<int>> {
  /// {@macro bytes_response_body}
  const BytesResponseBody(super.data);
}
