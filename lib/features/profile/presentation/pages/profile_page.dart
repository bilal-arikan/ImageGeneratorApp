import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:image_generator_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          IconButton(
            onPressed: () => _showEditProfileDialog(context, ref),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _showSignOutDialog(context, ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(profileControllerProvider.notifier).loadProfile(),
        child: profileState.when(
          data: (profile) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? Text(
                        profile.fullName[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                profile.fullName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              _InfoCard(
                title: 'Kredilerim',
                value: profile.credits.toString(),
                onTap: () => context.go('/credits'),
              ),
              if (profile.referenceCode != null) ...[
                const SizedBox(height: 16),
                _InfoCard(
                  title: 'Referans Kodum',
                  value: profile.referenceCode!,
                  onTap: () {
                    // TODO: Kopyalama işlemi
                  },
                ),
              ],
              const SizedBox(height: 16),
              _InfoCard(
                title: 'Üyelik Tarihi',
                value: DateFormat('dd.MM.yyyy').format(profile.createdAt),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () => _showDeleteAccountDialog(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Hesabımı Sil'),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hata: $error',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .read(profileControllerProvider.notifier)
                      .loadProfile(),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditProfileDialog(
      BuildContext context, WidgetRef ref) async {
    final profile = ref.read(profileControllerProvider).value;
    if (profile == null) return;

    final nameController = TextEditingController(text: profile.fullName);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profili Düzenle'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Ad Soyad',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result == true) {
      // ignore: use_build_context_synchronously
      await ref
          .read(profileControllerProvider.notifier)
          .updateProfile(fullName: nameController.text);
    }
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );

    if (result == true) {
      // ignore: use_build_context_synchronously
      await ref.read(authControllerProvider.notifier).signOut();
      // ignore: use_build_context_synchronously
      context.go('/signin');
    }
  }

  Future<void> _showDeleteAccountDialog(
      BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Hesabı Sil'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        // ignore: use_build_context_synchronously
        await ref.read(profileControllerProvider.notifier).deleteAccount();
        // ignore: use_build_context_synchronously
        await ref.read(authControllerProvider.notifier).signOut();
        // ignore: use_build_context_synchronously
        context.go('/signin');
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
