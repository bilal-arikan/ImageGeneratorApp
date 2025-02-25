import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'reference_code') String? referenceCode,
    @JsonKey(name: 'referred_by') String? referredBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    required int credits,
    @JsonKey(name: 'credits_history') List<CreditHistory>? creditsHistory,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

@freezed
class CreditHistory with _$CreditHistory {
  const factory CreditHistory({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required int amount,
    @JsonKey(name: 'transaction_type') required String transactionType,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CreditHistory;

  factory CreditHistory.fromJson(Map<String, dynamic> json) =>
      _$CreditHistoryFromJson(json);
}
