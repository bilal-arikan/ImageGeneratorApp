import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Çıkış Yap'),
                  content:
                      const Text('Çıkış yapmak istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Çıkış Yap'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(authProviderProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileHeader(
              profile: profile!,
              user: ref.watch(authProviderProvider).value!,
            ),
            const SizedBox(height: 24),
            ProfileMenuItem(
              icon: Icons.credit_card,

              title: 'Kredi Satın Al',
              // subtitle: '${profile.creditBalance} krediniz var', // TODO: Kredi satın alma sayfası eklendikten sonra burayı düzenleyeceğiz
              onTap: () {
                context.push(RoutePaths.credits);
              },
            ),
            const Divider(),
            ProfileMenuItem(
              icon: Icons.image,
              title: 'Oluşturduklarım',
              onTap: () {
                context.push(RoutePaths.myGenerations);
              },
            ),
            const Divider(),
            ProfileMenuItem(
              icon: Icons.settings,
              title: 'Ayarlar',
              onTap: () {
                context.push(RoutePaths.settings);
              },
            ),
            const Divider(),
            ProfileMenuItem(
              icon: Icons.delete_forever,
              title: 'Hesabı Sil',
              iconColor: Colors.red,
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hesabı Sil'),
                    content: const Text(
                      'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('İptal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Hesabı Sil'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref
                      .read(profileProviderProvider.notifier)
                      .deleteProfile();
                }
              },
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Hata: $error'),
        ),
      ),
    );
  }
}
