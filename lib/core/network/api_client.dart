import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  static const _baseUrl = 'http://192.168.1.12:54321/functions/v1';

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // Auth token'ı header'lara ekleyen yardımcı metod
  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  // GET isteği
  Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers(token),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // POST isteği
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers(token),
        body: data != null ? json.encode(data) : null,
      );

      final body = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw ApiException(
          body['error'] ?? 'Bir hata oluştu',
          statusCode: response.statusCode,
        );
      }

      return body;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Bağlantı hatası: ${e.toString()}');
    }
  }

  // PUT isteği
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> data,
    String? token,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers(token),
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // DELETE isteği
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers(token),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Response handler
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    switch (response.statusCode) {
      case 401:
        throw UnauthorizedException(body['message'] ?? 'Unauthorized');
      case 403:
        throw ForbiddenException(body['message'] ?? 'Forbidden');
      case 404:
        throw NotFoundException(body['message'] ?? 'Not found');
      default:
        throw ApiException(
          body['message'] ?? 'Something went wrong',
        );
    }
  }
}

// Custom exceptions
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message);
}
