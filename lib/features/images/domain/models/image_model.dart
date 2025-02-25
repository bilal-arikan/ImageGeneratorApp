import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

@freezed
class ImageModel with _$ImageModel {
  const factory ImageModel({
    required String id,
    required String userId,
    required String prompt,
    String? negativePrompt,
    required String imageUrl,
    required String style,
    required int width,
    required int height,
    @Default(false) bool isPublic,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}

@freezed
class ImageStyle with _$ImageStyle {
  const factory ImageStyle({
    required String id,
    required String name,
    required String description,
    String? previewUrl,
    @Default(true) bool isActive,
  }) = _ImageStyle;

  factory ImageStyle.fromJson(Map<String, dynamic> json) =>
      _$ImageStyleFromJson(json);
}
