import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/utils/error_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final fullNameController = useTextEditingController();
    final errorMessage = useState<String?>(null);

    // Auth state'i dinle
    final authState = ref.watch(authProviderProvider);

    useEffect(() {
      return () {
        emailController.dispose();
        phoneController.dispose();
        passwordController.dispose();
        fullNameController.dispose();
      };
    }, []);

    Future<void> handleSignUp() async {
      if (!formKey.currentState!.validate()) return;

      errorMessage.value = null;

      try {
        await ref.read(authProviderProvider.notifier).signUp(
              email: emailController.text,
              phone: phoneController.text,
              password: passwordController.text,
              fullName: fullNameController.text,
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
        title: const Text('Hesap Oluştur'),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppTextField(
                controller: emailController,
                label: 'E-posta',
                hint: 'ornek@mail.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta gerekli';
                  }
                  if (!value.contains('@')) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: phoneController,
                label: 'Telefon',
                hint: '5XX XXX XX XX',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefon numarası gerekli';
                  }
                  if (value.length != 10) {
                    return 'Geçerli bir telefon numarası girin';
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
                text: 'Hesap Oluştur',
                onPressed: handleSignUp,
                isLoading: authState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
