import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

class AppNavDestination {
  final String route;
  final String label;
  final IconData icon;

  const AppNavDestination({
    required this.route,
    required this.label,
    required this.icon,
  });
}

class AppNavigationIndicator extends StatelessWidget {
  final List<AppNavDestination> destinations;

  const AppNavigationIndicator({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.toString();
    final activeIndex = destinations.indexWhere(
      (destination) => location.startsWith(destination.route),
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSpacing.md,
            sigmaY: AppSpacing.md,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < destinations.length; index++)
                _NavigationItem(
                  destination: destinations[index],
                  active: index == activeIndex,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final AppNavDestination destination;
  final bool active;

  const _NavigationItem({required this.destination, required this.active});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(destination.icon, size: AppSpacing.lg, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(
            destination.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: active ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
