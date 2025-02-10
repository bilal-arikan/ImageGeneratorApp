import 'package:ai_image_generator/core/network/api_endpoints.dart';
import 'package:ai_image_generator/features/auth/data/auth_repository.dart';
import 'package:ai_image_generator/features/auth/presentation/providers/auth_provider.dart';
import 'package:ai_image_generator/features/profile/models/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileProvider extends _$ProfileProvider {
  @override
  FutureOr<Profile?> build() async {
    final authState = ref.watch(authProviderProvider);

    if (authState.isLoading) {
      return Future.delayed(const Duration(seconds: 1));
    }

    final user = authState.valueOrNull;
    if (user == null) {
      throw Exception('Kullanıcı girişi yapılmamış');
    }

    final response = await ref.read(apiClientProvider).get(
          ApiEndpoints.getProfile,
          token: await ref.read(authTokenProvider.future),
        );

    if (response == null) {
      throw Exception('Profil bilgileri alınamadı');
    }

    final profile = Profile.fromJson(response['profile']);

    return Profile(
      id: user.id,
      fullName: profile.fullName,
      profileImageUrl: profile.profileImageUrl,
      createdAt: user.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  Future<Profile?> updateProfile({
    String? fullName,
    String? profileImageUrl,
  }) async {
    state = const AsyncLoading();

    try {
      final updatedUser =
          await ref.read(profileProviderProvider.notifier).updateProfile(
                fullName: fullName,
                profileImageUrl: profileImageUrl,
              );

      if (updatedUser == null) {
        return null;
      }

      state = AsyncData(Profile(
        id: updatedUser.id,
        fullName: updatedUser.fullName,
        profileImageUrl: updatedUser.profileImageUrl,
        createdAt: updatedUser.createdAt,
        updatedAt: updatedUser.updatedAt,
      ));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteProfile() async {
    state = const AsyncLoading();

    try {
      await ref.read(profileProviderProvider.notifier).deleteProfile();
      await ref.read(authProviderProvider.notifier).signOut();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}
