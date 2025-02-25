import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/features/discover/presentation/controllers/discover_controller.dart';
import 'package:image_generator_app/features/discover/presentation/widgets/image_grid.dart';

class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesState = ref.watch(discoverControllerProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Keşfet'),
          floating: true,
        ),
        const SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Son Oluşturulan Görseller',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: imagesState.when(
            data: (images) => ImageGrid(
              images: images,
              onImageTap: (image) {
                // TODO: Resim detay sayfasına yönlendirilecek
              },
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: Center(
                child: Text('Hata: $error'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
