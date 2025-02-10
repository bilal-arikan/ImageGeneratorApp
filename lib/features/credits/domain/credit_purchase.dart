import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_purchase.freezed.dart';
part 'credit_purchase.g.dart';

@freezed
class CreditPurchase with _$CreditPurchase {
  const factory CreditPurchase({
    required String packageId,
    required int amount,
    required double price,
    String? currency,
  }) = _CreditPurchase;

  factory CreditPurchase.fromJson(Map<String, dynamic> json) =>
      _$CreditPurchaseFromJson(json);
}
