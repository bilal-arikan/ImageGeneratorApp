import 'package:ai_image_generator/features/profile/presentation/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/auth_provider.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/reset_password_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/home/presentation/discover_page.dart';
import '../../features/home/presentation/generate_page.dart';
import '../../features/home/presentation/my_generations_page.dart';
import '../../features/intro/presentation/intro_page.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authProvider);
  final hasSeenIntro = ref.watch(hasSeenIntroProvider);

  return GoRouter(
    initialLocation: '/intro',
    redirect: (context, state) {
      if (!hasSeenIntro && state.matchedLocation != '/intro') {
        return '/intro';
      }

      if (hasSeenIntro && state.matchedLocation == '/intro') {
        return '/login';
      }

      if (authState.isLoading || state.matchedLocation == '/intro') {
        return null;
      }

      if (authState.hasError) {
        return '/login';
      }

      final authData = authState.valueOrNull;
      if (authData == null) return null;

      final isAuthenticated = authData.whenOrNull(
            authenticated: (_) => true,
          ) ??
          false;

      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/reset-password';

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/intro',
        builder: (context, state) => const IntroPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomePage(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeContent(),
          ),
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoverPage(),
          ),
          GoRoute(
            path: '/generate',
            builder: (context, state) => const GeneratePage(),
          ),
          GoRoute(
            path: '/my-generations',
            builder: (context, state) => const MyGenerationsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}

@riverpod
class HasSeenIntro extends _$HasSeenIntro {
  @override
  bool build() => false;

  void markAsSeen() => state = true;
}
