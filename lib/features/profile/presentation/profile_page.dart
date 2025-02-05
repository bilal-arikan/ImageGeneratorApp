import 'package:ai_image_generator/core/providers/supabase_provider.dart';
import 'package:ai_image_generator/features/auth/providers/auth_provider.dart';
import 'package:ai_image_generator/features/profile/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (state) => state.maybeWhen(
        authenticated: (user) {
          final profile = ref.watch(profileServiceProvider(user.id));

          return profile.when(
            data: (profile) => Scaffold(
              appBar: AppBar(
                title: const Text('Profil'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditDialog(context, ref, profile),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profile.avatarUrl != null
                              ? NetworkImage(profile.avatarUrl!)
                              : null,
                          child: profile.avatarUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () =>
                                _updateAvatar(context, ref, profile),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Kullanıcı Adı'),
                    subtitle: Text(profile.username),
                  ),
                  ListTile(
                    title: const Text('E-posta'),
                    subtitle: Text(user.email),
                  ),
                  ListTile(
                    title: const Text('Krediler'),
                    subtitle: Text('${profile.credits} kredi'),
                    trailing: SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () =>
                            _showBuyCreditsDialog(context, ref, profile),
                        child: const Text('Kredi Al'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Hata: $error')),
          );
        },
        orElse: () => const SizedBox(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Hata: $error')),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final controller = TextEditingController(text: profile.username);
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profili Düzenle'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
            validator: (value) {
              if (value == null || value.length < 3) {
                return 'Kullanıcı adı en az 3 karakter olmalıdır';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await ref
                      .read(profileServiceProvider(profile.id).notifier)
                      .updateProfile(
                        userId: profile.id,
                        username: controller.text,
                      );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hata: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateAvatar(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    if (context.mounted) {
      try {
        final bytes = await image.readAsBytes();
        final ext = image.path.split('.').last;
        final path = 'avatars/${profile.id}.$ext';

        // Upload to Supabase Storage
        await ref
            .read(supabaseProvider)
            .storage
            .from('public')
            .uploadBinary(path, bytes);

        final avatarUrl = ref
            .read(supabaseProvider)
            .storage
            .from('public')
            .getPublicUrl(path);

        // Update profile with new avatar URL
        await ref
            .read(profileServiceProvider(profile.id).notifier)
            .updateProfile(
              userId: profile.id,
              avatarUrl: avatarUrl,
            );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e')),
          );
        }
      }
    }
  }

  Future<void> _showBuyCreditsDialog(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    final packages = [
      (amount: 10, price: '10₺'),
      (amount: 50, price: '45₺'),
      (amount: 100, price: '80₺'),
    ];

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kredi Satın Al'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final package in packages)
              ListTile(
                title: Text('${package.amount} Kredi'),
                subtitle: Text(package.price),
                trailing: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Burada ödeme işlemi yapılacak
                      await ref
                          .read(profileServiceProvider(profile.id).notifier)
                          .updateCredits(
                            profile.id,
                            profile.credits + package.amount,
                          );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Krediler başarıyla eklendi'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hata: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Satın Al'),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}
