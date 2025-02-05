import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/theme/auth_theme.dart';

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
              padding: AuthTheme.cardPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'E-posta adresinizi girin. Size şifre sıfırlama bağlantısı göndereceğiz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: AuthTheme.inputDecoration(
                      context,
                      labelText: 'E-posta',
                      errorText: errorText.value,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => errorText.value = null,
                  ),
                  const SizedBox(height: 24),
                  authState.when(
                    data: (_) => ElevatedButton(
                      onPressed: () async {
                        try {
                          await ref.read(authProvider.notifier).resetPassword(
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
                      style: AuthTheme.elevatedButtonStyle(context),
                      child: const Text('Şifre Sıfırlama Bağlantısı Gönder'),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) {
                      errorText.value = error.toString();
                      return ElevatedButton(
                        onPressed: () =>
                            ref.read(authProvider.notifier).resetPassword(
                                  emailController.text,
                                ),
                        style: AuthTheme.elevatedButtonStyle(context),
                        child: const Text('Tekrar Dene'),
                      );
                    },
                  ),
                  TextButton(
                    style: AuthTheme.textButtonStyle(),
                    onPressed: () => context.pop(),
                    child: const Text('Giriş sayfasına dön'),
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
