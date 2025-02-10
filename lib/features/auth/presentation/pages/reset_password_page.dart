import 'package:ai_image_generator/core/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/utils/error_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final errorMessage = useState<String?>(null);
    final isLoading = useState(false);

    useEffect(() {
      return () {
        emailController.dispose();
      };
    }, []);

    Future<void> handleResetPassword() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;
      errorMessage.value = null;

      try {
        await ref
            .read(authProviderProvider.notifier)
            .resetPassword(emailController.text);
        if (context.mounted) {
          ref.read(snackbarServiceProvider).showSuccess(
                'Şifre sıfırlama talimatları e-posta adresinize gönderildi',
              );
          context.pop();
        }
      } catch (e) {
        if (context.mounted) {
          errorMessage.value = ErrorUtils.getErrorMessage(e);
          ErrorUtils.showError(ref, e);
        }
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Şifrenizi sıfırlamak için e-posta adresinizi girin. '
                'Size şifre sıfırlama talimatlarını göndereceğiz.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: emailController,
                label: 'E-posta',
                hint: 'ornek@mail.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
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
                text: 'Şifremi Sıfırla',
                onPressed: handleResetPassword,
                isLoading: isLoading.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
