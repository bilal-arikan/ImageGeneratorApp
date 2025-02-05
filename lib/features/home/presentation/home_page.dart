import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class HomePage extends HookConsumerWidget {
  final Widget child;

  const HomePage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('AI Image Generator'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: authState.when(
        data: (state) => state.maybeWhen(
          authenticated: (_) => child,
          orElse: () => const SizedBox(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Hata: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFeatureCard(
            context,
            'Yeni Resim Oluştur',
            'AI ile yeni resimler oluşturun',
            Icons.add_photo_alternate,
            '/generate',
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            'Oluşturulanları Keşfet',
            'Diğer kullanıcıların oluşturduğu resimleri görün',
            Icons.explore,
            '/discover',
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            'Oluşturduklarım',
            'Oluşturduğunuz resimleri görüntüleyin',
            Icons.photo_library,
            '/my-generations',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle,
      IconData icon, String route) {
    return Card(
      child: InkWell(
        onTap: () => context.go(route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final selectedIndex = switch (currentLocation) {
      '/home' => 0,
      '/discover' => 1,
      '/generate' => 2,
      '/my-generations' => 3,
      '/profile' => 4,
      _ => 0,
    };

    return NavigationBar(
      selectedIndex: selectedIndex,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Ana Sayfa',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore),
          label: 'Keşfet',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          label: 'Oluştur',
        ),
        NavigationDestination(
          icon: Icon(Icons.photo_library),
          label: 'Galeri',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/discover');
            break;
          case 2:
            context.go('/generate');
            break;
          case 3:
            context.go('/my-generations');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
    );
  }
}
