import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/theme/auth_theme.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: "t@t.com");
    final passwordController = useTextEditingController(text: "111111");
    final authState = ref.watch(authProvider);
    final errorText = useState<String?>(null);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Giriş Yap'),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: AuthTheme.inputDecoration(
                      context,
                      labelText: 'Şifre',
                    ),
                    obscureText: true,
                    onChanged: (_) => errorText.value = null,
                  ),
                  const SizedBox(height: 24),
                  authState.when(
                    data: (_) => ElevatedButton(
                      onPressed: () async {
                        try {
                          await ref.read(authProvider.notifier).signIn(
                                emailController.text,
                                passwordController.text,
                              );
                        } catch (e) {
                          errorText.value = e.toString();
                        }
                      },
                      style: AuthTheme.elevatedButtonStyle(context),
                      child: const Text('Giriş Yap'),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) {
                      errorText.value = error.toString();
                      return ElevatedButton(
                        onPressed: () => ref.read(authProvider.notifier).signIn(
                              emailController.text,
                              passwordController.text,
                            ),
                        style: AuthTheme.elevatedButtonStyle(context),
                        child: const Text('Tekrar Dene'),
                      );
                    },
                  ),
                  TextButton(
                    style: AuthTheme.textButtonStyle(),
                    onPressed: () => context.push('/register'),
                    child: const Text('Hesabın yok mu? Kayıt ol'),
                  ),
                  TextButton(
                    style: AuthTheme.textButtonStyle(),
                    onPressed: () => context.push('/reset-password'),
                    child: const Text('Şifreni mi unuttun?'),
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
