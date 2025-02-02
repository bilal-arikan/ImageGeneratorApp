import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/router/router.dart';
import '../models/intro_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IntroPage extends HookConsumerWidget {
  const IntroPage({super.key});

  static const _items = [
    IntroItem(
      title: 'AI ile Resim Oluşturma',
      description:
          'Yapay zeka teknolojisi ile hayal ettiğiniz resimleri saniyeler içinde oluşturun',
      imagePath:
          'https://images.unsplash.com/photo-1738236013982-9449791344de?q=80&w=1873',
    ),
    IntroItem(
      title: 'Topluluk Keşfi',
      description:
          'Diğer kullanıcıların oluşturduğu resimleri keşfedin ve ilham alın',
      imagePath:
          'https://images.unsplash.com/photo-1738369350430-87d667611998?q=80&w=2574',
    ),
    IntroItem(
      title: 'Kişisel Galeri',
      description: 'Oluşturduğunuz tüm resimleri kişisel galerinizde saklayın',
      imagePath:
          'https://images.unsplash.com/photo-1587069887512-50bc3cceb037?q=80&w=2512',
    ),
    IntroItem(
      title: 'Paylaşım ve Etkileşim',
      description: 'Resimlerinizi toplulukla paylaşın, beğeni ve yorumlar alın',
      imagePath:
          'https://images.unsplash.com/photo-1683009427479-c7e36bbb7bca?q=80&w=1000',
    ),
    IntroItem(
      title: 'Başlayalım!',
      description: 'Hemen üye olun ve yaratıcılığınızı keşfetmeye başlayın',
      imagePath:
          'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?q=80&w=1000',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);

    return Scaffold(
      body: Stack(
        children: [
          // Full screen PageView
          PageView.builder(
            controller: pageController,
            itemCount: _items.length,
            onPageChanged: (index) => currentPage.value = index,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = _items[index];
              return Stack(
                children: [
                  // Fullscreen resim
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: CachedNetworkImage(
                      imageUrl: item.imagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.error_outline,
                          size: 120,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // İçerik alanı - alt kısımda
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Text(
                                  item.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  item.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          // Page indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _items.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage.value == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Başla butonu
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(hasSeenIntroProvider.notifier)
                                    .markAsSeen();
                                context.go('/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Hadi Başlayalım',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Navigation buttons
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sol buton
                    if (currentPage.value > 0)
                      IconButton(
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    else
                      const SizedBox(width: 48), // Sol tarafta boşluk

                    // Sağ buton
                    if (currentPage.value < _items.length - 1)
                      IconButton(
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    else
                      const SizedBox(width: 48), // Sağ tarafta boşluk
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
