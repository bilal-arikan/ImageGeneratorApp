import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:image_generator_app/features/auth/presentation/pages/signin_page.dart';
import 'package:image_generator_app/features/auth/presentation/pages/signup_page.dart';
import 'package:image_generator_app/features/home/presentation/pages/home_page.dart';
import 'package:image_generator_app/features/info/presentation/pages/info_page.dart';
import 'package:image_generator_app/features/splash/presentation/pages/splash_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/info',
        builder: (context, state) => const InfoPage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});
