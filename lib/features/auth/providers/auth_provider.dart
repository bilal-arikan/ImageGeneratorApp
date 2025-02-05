import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User, AuthState;
import '../models/auth_state.dart';
import '../models/user.dart';
import '../../../core/providers/supabase_provider.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Stream<AuthState> build() {
    return ref.watch(supabaseProvider).auth.onAuthStateChange.map((event) {
      final session = event.session;
      final user =
          event.event == AuthChangeEvent.signedIn ? session?.user : null;

      if (user == null) {
        return const AuthState.unauthenticated();
      }

      return AuthState.authenticated(
        User(
          id: user.id,
          email: user.email ?? '',
          phone: user.phone,
          createdAt: user.createdAt,
        ),
      );
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await ref.read(supabaseProvider).auth.signInWithPassword(
            email: email,
            password: password,
          );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signUp(String email, String password, String phone) async {
    try {
      final response = await ref.read(supabaseProvider).auth.signUp(
            email: email,
            password: password,
            data: {'phone': phone},
            emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
          );

      if (response.user == null) {
        throw 'Kayıt işlemi başarısız oldu';
      }

      if (response.user?.emailConfirmedAt == null) {
        throw 'Lütfen e-posta adresinize gönderilen doğrulama bağlantısına tıklayın';
      }
    } catch (e) {
      if (e is AuthException) {
        switch (e.message) {
          case 'Password should be at least 6 characters':
            throw 'Şifre en az 6 karakter olmalıdır';
          case 'User already registered':
            throw 'Bu e-posta adresi zaten kayıtlı';
          case 'Invalid email':
            throw 'Geçersiz e-posta adresi';
          default:
            throw e.message;
        }
      }
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(supabaseProvider).auth.signOut();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await ref.read(supabaseProvider).auth.resetPasswordForEmail(email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'E-posta veya şifre hatalı';
        case 'Email not confirmed':
          return 'Lütfen e-posta adresinizi doğrulayın';
        case 'User already registered':
          return 'Bu e-posta adresi zaten kayıtlı';
        case 'Password should be at least 6 characters':
          return 'Şifre en az 6 karakter olmalıdır';
        default:
          return error.message;
      }
    }
    return error.toString();
  }
}
