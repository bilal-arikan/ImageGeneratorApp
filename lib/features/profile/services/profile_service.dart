import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/profile.dart';
import '../../../core/providers/supabase_provider.dart';

part 'profile_service.g.dart';

@riverpod
class ProfileService extends _$ProfileService {
  @override
  Future<Profile> build(String userId) async {
    final response = await ref
        .read(supabaseProvider)
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    // Null check ve varsayılan değerler
    return Profile.fromJson({
      ...response,
      'id': response['id'] ?? userId,
      'username': response['username'] ?? 'user_${userId.substring(0, 8)}',
      'credits': response['credits'] ?? 10,
    });
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
  }) async {
    final updates = {
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await ref
        .read(supabaseProvider)
        .from('profiles')
        .update(updates)
        .eq('id', userId);

    ref.invalidateSelf();
  }

  Future<void> updateCredits(String userId, int amount) async {
    await ref.read(supabaseProvider).from('profiles').update({
      'credits': amount,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    ref.invalidateSelf();
  }
}
