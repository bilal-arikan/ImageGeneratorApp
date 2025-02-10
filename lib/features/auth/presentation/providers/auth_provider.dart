import 'package:ai_image_generator/core/network/api_endpoints.dart';
import 'package:ai_image_generator/features/auth/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthProvider extends _$AuthProvider {
  @override
  FutureOr<User?> build() async {
    final tokenAsync = ref.watch(authTokenProvider);

    // Token yüklenene kadar bekle
    if (tokenAsync.isLoading) return null;

    // Token hatası varsa null dön
    if (tokenAsync.hasError) {
      await ref.read(authTokenProvider.notifier).clearToken();
      return null;
    }

    // Token yoksa null dön
    final token = tokenAsync.valueOrNull;
    if (token == null) return null;

    try {
      // Token varsa kullanıcı bilgilerini al
      final response = await ref.read(apiClientProvider).get(
            ApiEndpoints.getProfile,
            token: token,
          );

      if (response == null || response['user'] == null) {
        throw Exception('Kullanıcı bilgileri alınamadı');
      }

      return User.fromJson(response['user']);
    } catch (e) {
      // Hata durumunda token'ı temizle
      await ref.read(authTokenProvider.notifier).clearToken();
      return null;
    }
  }

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await ref.read(authRepositoryProvider.notifier).signIn(
            identifier: identifier,
            password: password,
          );

      print('Auth Response: $response'); // Debug için

      if (response['user'] == null) {
        throw Exception('Kullanıcı bilgileri alınamadı');
      }

      final user = User.fromJson(response['user']);
      state = AsyncData(user);
    } catch (e) {
      print('Auth Error: $e'); // Debug için
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String phone,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await ref.read(authRepositoryProvider.notifier).signUp(
            email: email,
            phone: phone,
            password: password,
            fullName: fullName,
          );

      final user = User.fromJson(response['user']);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    try {
      await ref.read(authRepositoryProvider.notifier).signOut();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await ref.read(authRepositoryProvider.notifier).resetPassword(email);
  }
}
