import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/core/constants/api_endpoints.dart';
import 'package:image_generator_app/core/services/http_service.dart';
import 'package:image_generator_app/features/auth/domain/models/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return AuthRepository(httpService);
});

class AuthRepository {
  final HttpService _httpService;

  AuthRepository(this._httpService);

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpService.post(
        ApiEndpoints.auth.signIn,
        body: {
          'identifier': email,
          'password': password,
        },
      );

      print(response);
      return UserModel.fromJson(response['user'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Giriş yapılırken bir hata oluştu: $e');
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _httpService.post(
        ApiEndpoints.auth.signUp,
        body: {
          'email': email,
          'password': password,
          'full_name': fullName,
        },
      );

      print(response);
      return UserModel.fromJson(response['user'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Kayıt olurken bir hata oluştu: $e');
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _httpService.post(
        ApiEndpoints.auth.forgotPassword,
        body: {'email': email},
      );
    } catch (e) {
      throw Exception('Şifre sıfırlama işlemi başarısız: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _httpService.post(ApiEndpoints.auth.signOut);
    } catch (e) {
      throw Exception('Çıkış yapılırken bir hata oluştu: $e');
    }
  }
}
