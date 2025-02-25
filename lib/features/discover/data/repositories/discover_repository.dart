import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_generator_app/core/constants/api_endpoints.dart';
import 'package:image_generator_app/core/services/http_service.dart';
import 'package:image_generator_app/features/images/domain/models/image_model.dart';

final discoverRepositoryProvider = Provider<DiscoverRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return DiscoverRepository(httpService);
});

class DiscoverRepository {
  final HttpService _httpService;

  DiscoverRepository(this._httpService);

  Future<List<ImageModel>> getLatestImages() async {
    try {
      final response = await _httpService.get(
        ApiEndpoints.discover.getImages(orderBy: 'created_at'),
      );

      print('Discover Response: $response'); // Debug için

      // API yanıtı direkt liste olarak geliyor
      return (response as List)
          .map((json) => ImageModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Discover Error: $e'); // Debug için
      throw Exception('Resimler yüklenirken bir hata oluştu: $e');
    }
  }
}
