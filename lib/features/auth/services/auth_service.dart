import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import '../models/fake_user.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) => AuthService();

class AuthService {
  FakeUser? _currentUser;
  bool _isAuthenticated = false;

  Future<void> signUp({
    required String email,
    required String password,
    required String phone,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = FakeUser(
      id: 'fake-user-id',
      email: email,
      phone: phone,
      createdAt: DateTime.now().toString(),
    );
    _isAuthenticated = true;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@test.com' && password == '123456') {
      _currentUser = FakeUser(
        id: 'fake-user-id',
        email: email,
        phone: '+905555555555',
        createdAt: DateTime.now().toString(),
      );
      _isAuthenticated = true;
      authStateChanges();
    } else {
      throw 'Geçersiz e-posta veya şifre';
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    _isAuthenticated = false;
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Stream<AuthState> authStateChanges() async* {
    yield const AuthState.initial();

    if (_isAuthenticated && _currentUser != null) {
      yield AuthState.authenticated(_currentUser!);
    } else {
      yield const AuthState.unauthenticated();
    }
  }
}
