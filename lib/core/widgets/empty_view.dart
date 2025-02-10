import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyView({
    super.key,
    required this.message,
    this.icon,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            if (icon != null) const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
