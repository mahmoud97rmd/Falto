import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class RestClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  RestClient({
    required this.baseUrl,
    Map<String, String>? defaultHeaders,
  }) : defaultHeaders = defaultHeaders ?? {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint).replace(queryParameters: query);
    final mergedHeaders = {...defaultHeaders, ...?headers};

    final response = await http.get(uri, headers: mergedHeaders);
    _validateResponse(response);
    return response;
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint);
    final mergedHeaders = {...defaultHeaders, ...?headers};

    final response = await http.post(
      uri,
      headers: mergedHeaders,
      body: jsonEncode(body),
    );

    _validateResponse(response);
    return response;
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint);
    final mergedHeaders = {...defaultHeaders, ...?headers};

    final response = await http.delete(uri, headers: mergedHeaders);
    _validateResponse(response);
    return response;
  }

  void _validateResponse(http.Response response) {
    if (response.statusCode >= 400) {
      throw RestException(
        response.statusCode,
        response.body,
      );
    }
  }
}

class RestException implements Exception {
  final int statusCode;
  final String body;

  RestException(this.statusCode, this.body);

  @override
  String toString() =>
      'RestException(statusCode: $statusCode, body: $body)';
}
