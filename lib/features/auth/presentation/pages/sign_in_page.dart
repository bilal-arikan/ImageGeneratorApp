import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_paths.dart';
import '../../../../core/utils/error_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController(text: "q@q.com");
    final passwordController = useTextEditingController(text: "999999");
    final errorMessage = useState<String?>(null);

    // Auth state'i dinle
    final authState = ref.watch(authProviderProvider);

    useEffect(() {
      return () {
        // emailController.dispose();
        // passwordController.dispose();
      };
    }, []);

    Future<void> handleSignIn() async {
      if (!formKey.currentState!.validate()) return;

      errorMessage.value = null;

      try {
        await ref.read(authProviderProvider.notifier).signIn(
              identifier: emailController.text,
              password: passwordController.text,
            );
      } catch (e) {
        if (context.mounted) {
          errorMessage.value = ErrorUtils.getErrorMessage(e);
          ErrorUtils.showError(ref, e);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppTextField(
                controller: emailController,
                label: 'E-posta veya Telefon',
                hint: 'ornek@mail.com veya 5XX XXX XX XX',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta veya telefon gerekli';
                  }
                  final isEmail = value.contains('@');
                  final isPhone =
                      value.length == 10 && int.tryParse(value) != null;
                  if (!isEmail && !isPhone) {
                    return 'Geçerli bir e-posta veya telefon numarası girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: passwordController,
                label: 'Şifre',
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şifre gerekli';
                  }
                  if (value.length < 6) {
                    return 'Şifre en az 6 karakter olmalı';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              if (errorMessage.value != null) ...[
                const SizedBox(height: 16),
                SelectableText.rich(
                  TextSpan(
                    text: errorMessage.value,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              AppButton(
                text: 'Giriş Yap',
                onPressed: handleSignIn,
                isLoading: authState.isLoading,
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Hesap Oluştur',
                onPressed: () {
                  context.push(RoutePaths.auth + '/register');
                },
                isOutlined: true,
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Şifremi Unuttum',
                onPressed: () {
                  context.push('${RoutePaths.auth}/reset-password');
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
