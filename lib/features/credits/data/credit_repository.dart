import 'package:ai_image_generator/features/credits/domain/credit_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_endpoints.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/credit_transaction.dart';

part 'credit_repository.g.dart';

@Riverpod(keepAlive: true)
class CreditRepository extends _$CreditRepository {
  @override
  FutureOr<void> build() {}

  Future<int> getCreditBalance() async {
    final token = await ref.read(authTokenProvider.future);
    final response = await ref.read(apiClientProvider).get(
          ApiEndpoints.creditBalance,
          token: token,
        );
    return response['balance'] as int;
  }

  Future<List<CreditTransaction>> getCreditHistory() async {
    final token = await ref.read(authTokenProvider.future);
    final response = await ref.read(apiClientProvider).get(
          ApiEndpoints.creditHistory,
          token: token,
        );
    return (response['transactions'] as List)
        .map((e) => CreditTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> purchaseCredits(CreditPurchase purchase) async {
    final token = await ref.read(authTokenProvider.future);
    await ref.read(apiClientProvider).post(
          ApiEndpoints.purchaseCredits,
          data: purchase.toJson(),
          token: token,
        );
  }
}
