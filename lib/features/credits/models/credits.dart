import 'package:freezed_annotation/freezed_annotation.dart';

part 'credits.freezed.dart';
part 'credits.g.dart';

@freezed
class Credits with _$Credits {
  const factory Credits({
    required String userId,
    @Default(0) int amount,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Credits;

  factory Credits.fromJson(Map<String, dynamic> json) =>
      _$CreditsFromJson(json);
}
