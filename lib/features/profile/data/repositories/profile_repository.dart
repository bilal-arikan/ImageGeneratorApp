import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/core/constants/api_endpoints.dart';
import 'package:image_generator_app/core/services/http_service.dart';
import 'package:image_generator_app/features/profile/domain/models/profile_model.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return ProfileRepository(httpService);
});

class ProfileRepository {
  final HttpService _httpService;

  ProfileRepository(this._httpService);

  Future<ProfileModel> getMyProfile() async {
    try {
      final response = await _httpService.post(ApiEndpoints.user.profile);
      print('Profile Response: $response');
      if (response == null) {
        throw Exception('Profil bilgileri boş geldi');
      }
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Profil bilgileri alınamadı: $e');
    }
  }

  Future<ProfileModel> updateProfile({
    required String fullName,
    String? avatarUrl,
  }) async {
    try {
      final response = await _httpService.put(
        ApiEndpoints.user.updateProfile,
        body: {
          'full_name': fullName,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        },
      );
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Profil güncellenemedi: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _httpService.delete(ApiEndpoints.user.deleteAccount);
    } catch (e) {
      throw Exception('Hesap silinemedi: $e');
    }
  }
}
