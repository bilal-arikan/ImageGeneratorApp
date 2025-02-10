import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_paths.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo veya başlık
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            const Text(
              'AI Image Generator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                context.go(RoutePaths.auth);
              },
              child: const Text('Başla'),
            ),
          ],
        ),
      ),
    );
  }
}
