import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/features/profile/data/repositories/profile_repository.dart';
import 'package:image_generator_app/features/profile/domain/models/profile_model.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<ProfileModel>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileController(repository);
});

class ProfileController extends StateNotifier<AsyncValue<ProfileModel>> {
  final ProfileRepository _repository;

  ProfileController(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final profile = await _repository.getMyProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProfile({
    required String fullName,
    String? avatarUrl,
  }) async {
    try {
      state = const AsyncValue.loading();
      final profile = await _repository.updateProfile(
        fullName: fullName,
        avatarUrl: avatarUrl,
      );
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _repository.deleteAccount();
    } catch (error) {
      rethrow;
    }
  }
}
