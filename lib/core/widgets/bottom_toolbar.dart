import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/widgets/toolbar_action.dart';

class BottomToolbarItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const BottomToolbarItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class BottomToolbar extends StatelessWidget {
  final List<BottomToolbarItem> items;

  const BottomToolbar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppRadius.pill);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSpacing.md,
            sigmaY: AppSpacing.md,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.1),
              borderRadius: borderRadius,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.toolbarGlassStart.withValues(alpha: 0.16),
                    AppColors.toolbarGlassHighlight.withValues(alpha: 0.03),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final item in items)
                      ToolbarAction(
                        icon: item.icon,
                        label: item.label,
                        onTap: item.onTap,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
