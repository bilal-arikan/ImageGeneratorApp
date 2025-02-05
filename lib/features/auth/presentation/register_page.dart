import 'package:ai_image_generator/core/theme/auth_theme.dart';
import 'package:ai_image_generator/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final phoneController = useTextEditingController();
    final authState = ref.watch(authProvider);
    final errorText = useState<String?>(null);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Kayıt Ol'),
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
                    controller: phoneController,
                    decoration: AuthTheme.inputDecoration(
                      context,
                      labelText: 'Telefon',
                    ),
                    keyboardType: TextInputType.phone,
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
                          await ref.read(authProvider.notifier).signUp(
                                emailController.text,
                                passwordController.text,
                                phoneController.text,
                              );
                        } catch (e) {
                          errorText.value = e.toString();
                        }
                      },
                      style: AuthTheme.elevatedButtonStyle(context),
                      child: const Text('Kayıt Ol'),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) {
                      errorText.value = error.toString();
                      return ElevatedButton(
                        onPressed: () => ref.read(authProvider.notifier).signUp(
                              emailController.text,
                              passwordController.text,
                              phoneController.text,
                            ),
                        style: AuthTheme.elevatedButtonStyle(context),
                        child: const Text('Tekrar Dene'),
                      );
                    },
                  ),
                  TextButton(
                    style: AuthTheme.textButtonStyle(),
                    onPressed: () => context.pop(),
                    child: const Text('Zaten hesabın var mı? Giriş yap'),
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
