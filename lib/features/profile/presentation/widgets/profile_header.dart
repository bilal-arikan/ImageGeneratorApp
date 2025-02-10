import 'package:ai_image_generator/features/auth/domain/user.dart';
import 'package:ai_image_generator/features/profile/models/profile.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final User user;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: profile.profileImageUrl != null
              ? NetworkImage(profile.profileImageUrl!)
              : null,
          child: profile.profileImageUrl == null
              ? Text(
                  profile.fullName?[0].toUpperCase() ?? '',
                  style: theme.textTheme.displayMedium,
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          profile.fullName ?? '',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          user.email!.isEmpty ? user.phone! : user.email!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
