import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/features/discover/presentation/pages/discover_page.dart';
import 'package:image_generator_app/features/generate/presentation/pages/generate_page.dart';
import 'package:image_generator_app/features/my_generations/presentation/pages/my_generations_page.dart';
import 'package:image_generator_app/features/profile/presentation/pages/profile_page.dart';
import 'package:image_generator_app/features/search/presentation/pages/search_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DiscoverPage(),
    SearchPage(),
    GeneratePage(),
    MyGenerationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box),
            label: 'Generate',
          ),
          NavigationDestination(
            icon: Icon(Icons.image),
            label: 'My Images',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
