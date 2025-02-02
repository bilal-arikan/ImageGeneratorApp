import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: 'test2@test.com');
    final passwordController = useTextEditingController(text: '123456');
    final phoneController = useTextEditingController(text: '+905555555555');
    final authState = ref.watch(authProvider);
    final errorText = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: const OutlineInputBorder(),
                  errorText: errorText.value,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => errorText.value = null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (_) => errorText.value = null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
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
                  child: const Text('Kayıt Ol'),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, _) {
                  errorText.value = error.toString();
                  return ElevatedButton(
                    onPressed: () => ref.read(authProvider.notifier).signUp(
                          emailController.text,
                          passwordController.text,
                          phoneController.text,
                        ),
                    child: const Text('Tekrar Dene'),
                  );
                },
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Zaten hesabın var mı? Giriş yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
