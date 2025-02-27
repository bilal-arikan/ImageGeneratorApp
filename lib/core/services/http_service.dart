import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final httpServiceProvider = Provider<HttpService>((ref) {
  return HttpService();
});

class HttpService {
  static const String _baseUrl = 'http://192.168.1.37:54321/functions/v1';
  static const String _baseStorageUrl = 'http://192.168.1.37:54321/storage/v1';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<dynamic> get(String path) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl$path'),
        headers: headers,
      );

      print(response.body);
      return _handleResponse(response);
    } catch (e) {
      throw HttpException(
        500,
        message: 'Bir ağ hatası oluştu: $e',
      );
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );

      print(response.body);
      final data = _handleResponse(response);

      // Auth token'ı kaydet
      if (path.contains('/auth/') && data != null) {
        final session = data['session'];
        if (session != null && session['access_token'] != null) {
          await _saveToken(session['access_token']);
        }
      }

      return data;
    } catch (e) {
      throw HttpException(
        500,
        message: 'Bir ağ hatası oluştu: $e',
      );
    }
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl$path'),
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );

      print(response.body);
      return _handleResponse(response);
    } catch (e) {
      throw HttpException(
        500,
        message: 'Bir ağ hatası oluştu: $e',
      );
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl$path'),
        headers: headers,
      );

      print(response.body);
      return _handleResponse(response);
    } catch (e) {
      throw HttpException(
        500,
        message: 'Bir ağ hatası oluştu: $e',
      );
    }
  }

  dynamic _handleResponse(http.Response response) {
    var body = response.body.isNotEmpty ? json.decode(response.body) : null;

    // TODO: Remove this after testing
    body = json.decode(json.encode(body).replaceAll(
        'http://kong:8000/storage/v1', HttpService._baseStorageUrl));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    switch (response.statusCode) {
      case 401:
        _deleteToken();
        throw HttpException(
          response.statusCode,
          message: 'Oturum süresi doldu veya geçersiz.',
        );
      case 403:
        throw HttpException(
          response.statusCode,
          message: 'Bu işlem için yetkiniz yok.',
        );
      case 404:
        throw HttpException(
          response.statusCode,
          message: 'İstenilen kaynak bulunamadı.',
        );
      case 422:
        final errors = body?['errors'];
        throw HttpException(
          response.statusCode,
          message: errors is List ? errors.join(', ') : 'Geçersiz veri.',
        );
      default:
        throw HttpException(
          response.statusCode,
          message: body?['message'] ?? 'Bir hata oluştu.',
        );
    }
  }
}

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException(this.statusCode, {required this.message});

  @override
  String toString() => 'HttpException: $statusCode - $message';
}
