import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

class ToolbarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ToolbarAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.xxl, color: color),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
          ),
        ),
      ],
    );

    return Tooltip(
      message: label,
      child: onTap == null
          ? content
          : InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: onTap,
              child: content,
            ),
    );
  }
}
