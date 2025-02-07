import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/credits.dart';
import '../../../core/providers/supabase_provider.dart';

part 'credits_service.g.dart';

@riverpod
class CreditsService extends _$CreditsService {
  @override
  Future<Credits> build(String userId) async {
    final response = await ref
        .read(supabaseProvider)
        .from('credits')
        .select()
        .eq('user_id', userId)
        .single();

    return Credits.fromJson(response);
  }

  Future<void> updateCredits(String userId, int amount) async {
    await ref.read(supabaseProvider).from('credits').upsert({
      'user_id': userId,
      'amount': amount,
      'updated_at': DateTime.now().toIso8601String(),
    });

    ref.invalidateSelf();
  }

  Future<void> decrementCredits(String userId, {int amount = 1}) async {
    final credits = await future;
    if (credits.amount < amount) {
      throw 'Yetersiz kredi';
    }

    await updateCredits(userId, credits.amount - amount);
  }

  Future<void> addCredits(String userId, int amount) async {
    final credits = await future;
    await updateCredits(userId, credits.amount + amount);
  }
}
