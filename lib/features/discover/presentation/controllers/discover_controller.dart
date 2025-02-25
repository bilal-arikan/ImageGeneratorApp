import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/features/discover/data/repositories/discover_repository.dart';
import 'package:image_generator_app/features/images/domain/models/image_model.dart';

final discoverControllerProvider =
    StateNotifierProvider<DiscoverController, AsyncValue<List<ImageModel>>>(
        (ref) {
  final repository = ref.watch(discoverRepositoryProvider);
  return DiscoverController(repository);
});

class DiscoverController extends StateNotifier<AsyncValue<List<ImageModel>>> {
  final DiscoverRepository _repository;

  DiscoverController(this._repository) : super(const AsyncValue.loading()) {
    loadLatestImages();
  }

  Future<void> loadLatestImages() async {
    try {
      state = const AsyncValue.loading();
      final images = await _repository.getLatestImages();
      state = AsyncValue.data(images);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
