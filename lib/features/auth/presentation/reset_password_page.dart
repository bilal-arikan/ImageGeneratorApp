import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../../../core/widgets/gradient_background.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final authState = ref.watch(authProvider);
    final errorText = useState<String?>(null);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Şifre Sıfırlama'),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'E-posta adresinizi girin. Size şifre sıfırlama bağlantısı göndereceğiz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      border: const OutlineInputBorder(),
                      errorText: errorText.value,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => errorText.value = null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Giriş sayfasına dön'),
                      ),
                      authState.when(
                        data: (_) => ElevatedButton(
                          onPressed: () async {
                            try {
                              await ref.read(authServiceProvider).resetPassword(
                                    emailController.text,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Şifre sıfırlama bağlantısı gönderildi'),
                                  ),
                                );
                                context.go('/login');
                              }
                            } catch (e) {
                              errorText.value = e.toString();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child:
                              const Text('Şifre Sıfırlama Bağlantısı Gönder'),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, _) {
                          errorText.value = error.toString();
                          return ElevatedButton(
                            onPressed: () =>
                                ref.read(authServiceProvider).resetPassword(
                                      emailController.text,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Tekrar Dene'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
