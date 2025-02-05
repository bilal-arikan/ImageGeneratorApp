import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String username,
    String? avatarUrl,
    @Default(10) int credits,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson({
        ...json,
        'updated_at': json['updated_at'] ?? DateTime.now().toIso8601String(),
      });
}
