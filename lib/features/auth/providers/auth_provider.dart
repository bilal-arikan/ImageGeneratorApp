import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import '../models/fake_user.dart';
import '../services/auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Stream<AuthState> build() {
    return ref.watch(authServiceProvider).authStateChanges();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).signIn(
            email: email,
            password: password,
          );
      state = AsyncValue.data(AuthState.authenticated(FakeUser(
        id: 'fake-user-id',
        email: email,
        phone: '+905555555555',
        createdAt: DateTime.now().toString(),
      )));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signUp(String email, String password, String phone) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).signUp(
            email: email,
            password: password,
            phone: phone,
          );
      state = AsyncValue.data(AuthState.authenticated(FakeUser(
        id: 'fake-user-id',
        email: email,
        phone: phone,
        createdAt: DateTime.now().toString(),
      )));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).signOut();
      state = const AsyncValue.data(AuthState.unauthenticated());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
