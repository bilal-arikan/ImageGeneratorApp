import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/snackbar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      observers: [ErrorLogger()],
      child: const App(),
    ),
  );
}

class ErrorLogger extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint('Error in provider $provider: $error');
    Future.microtask(() {
      container.read(snackbarServiceProvider).showError(error.toString());
    });
  }
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: SnackbarService.key,
      title: 'AI Image Generator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        // Overlay için Navigator ekle
        return Navigator(
          onPopPage: (route, dynamic result) => false,
          pages: [
            MaterialPage(
              child: ErrorListener(
                child: child ?? const SizedBox(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ErrorListener extends ConsumerStatefulWidget {
  final Widget child;

  const ErrorListener({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ErrorListener> createState() => _ErrorListenerState();
}

class _ErrorListenerState extends ConsumerState<ErrorListener> {
  @override
  void initState() {
    super.initState();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      Future.microtask(() {
        if (mounted) {
          ref
              .read(snackbarServiceProvider)
              .showError(details.exception.toString());
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
