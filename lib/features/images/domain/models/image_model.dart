import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

@freezed
class ImageModel with _$ImageModel {
  const factory ImageModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String generator,
    required String workflow,
    @JsonKey(name: 'prompt_values') required Map<String, dynamic> promptValues,
    required Map<String, dynamic> outputs,
    required String status,
    String? error,
    @JsonKey(name: 'worker_id') String? workerId,
    required int attempts,
    @JsonKey(name: 'last_attempt') DateTime? lastAttempt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    UserInfo? user,
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

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
