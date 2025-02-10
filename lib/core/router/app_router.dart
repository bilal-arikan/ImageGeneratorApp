import 'package:ai_image_generator/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../constants/route_paths.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../core/providers/splash_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProviderProvider);
  final splashShown = ref.watch(splashShownProvider);

  return GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isOnAuthPage = state.matchedLocation.startsWith(RoutePaths.auth);
      final isOnSplashPage = state.matchedLocation == RoutePaths.splash;

      // Auth state yüklenene kadar bekle
      if (authState.isLoading) {
        return null; // Mevcut sayfada kal
      }

      // Auth state hazır
      if (authState.hasValue) {
        final user = authState.value;

        // Kullanıcı giriş yapmış
        if (user != null) {
          // Splash veya auth sayfasındaysa home'a yönlendir
          if (isOnSplashPage || isOnAuthPage) {
            return RoutePaths.home;
          }
          return null; // Diğer sayfalarda kalabilir
        }

        // Kullanıcı giriş yapmamış
        if (isOnSplashPage) {
          ref.read(splashShownProvider.notifier).markAsShown();
          // Splash gösterilmişse ve uygulama ilk kez açılmışsa auth'a yönlendir
          if (splashShown) {
            return RoutePaths.auth;
          }

          return null; // Splash'te kal
        }

        // Auth sayfasında değilse auth'a yönlendir
        if (!isOnAuthPage) {
          return RoutePaths.auth;
        }
        return null; // Auth sayfasında kal
      }

      // Auth state hata durumu - auth sayfasına yönlendir
      if (isOnSplashPage) {
        ref.read(splashShownProvider.notifier).markAsShown();
        return RoutePaths.auth;
      }
      return isOnAuthPage ? null : RoutePaths.auth;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.auth,
        builder: (context, state) => const SignInPage(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => const SignUpPage(),
          ),
          GoRoute(
            path: 'reset-password',
            builder: (context, state) => const ResetPasswordPage(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(),
      ),
      // TODO: Diğer route'lar eklenecek
    ],
  );
});
