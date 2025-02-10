import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

part 'auth_repository.g.dart';

const _tokenKey = 'auth_token';

@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  late final SharedPreferences _prefs;

  @override
  FutureOr<String?> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(_tokenKey);
  }

  Future<void> setToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    state = AsyncData(token);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
    state = const AsyncData(null);
  }
}

@Riverpod(keepAlive: true)
class AuthRepository extends _$AuthRepository {
  @override
  FutureOr<void> build() {}

  Future<Map<String, dynamic>> signIn({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await ref.read(apiClientProvider).post(
        ApiEndpoints.signIn,
        data: {
          'identifier': identifier,
          'password': password,
        },
      );

      if (response == null) {
        throw Exception('Sunucu yanıt vermedi');
      }

      print('SignIn Response: $response'); // Debug için

      if (response['session']['access_token'] == null) {
        throw Exception('Token alınamadı: ${response}');
      }

      // Token'ı cache'le
      await ref
          .read(authTokenProvider.notifier)
          .setToken(response['session']['access_token']);

      return response;
    } catch (e) {
      print('SignIn Error: $e'); // Debug için
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String phone,
    required String password,
    required String fullName,
  }) async {
    final response = await ref.read(apiClientProvider).post(
      ApiEndpoints.signUp,
      data: {
        'email': email,
        'phone': phone,
        'password': password,
        'full_name': fullName,
      },
    );

    if (response == null || response['token'] == null) {
      throw Exception('Kayıt başarısız');
    }

    // Token'ı cache'le
    await ref.read(authTokenProvider.notifier).setToken(response['token']);

    return response;
  }

  Future<void> signOut() async {
    final token = await ref.read(authTokenProvider.future);
    if (token != null) {
      await ref.read(apiClientProvider).post(
            ApiEndpoints.signOut,
            token: token,
          );
    }
    await ref.read(authTokenProvider.notifier).clearToken();
  }

  Future<void> resetPassword(String email) async {
    await ref.read(apiClientProvider).post(
      ApiEndpoints.resetPassword,
      data: {'email': email},
    );
  }
}

@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
}
