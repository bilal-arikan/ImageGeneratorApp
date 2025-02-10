import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_transaction.freezed.dart';
part 'credit_transaction.g.dart';

@freezed
class CreditTransaction with _$CreditTransaction {
  const factory CreditTransaction({
    required String id,
    required String userId,
    required String type,
    required int amount,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CreditTransaction;

  factory CreditTransaction.fromJson(Map<String, dynamic> json) =>
      _$CreditTransactionFromJson(json);
}
