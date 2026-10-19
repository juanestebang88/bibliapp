import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// 'DURACIÓN' tile: hourglass icon plus the calendar-day count since the
/// scope's first mark, e.g. '1 Día' / '13 Días' (spec 19).
class DurationTile extends StatelessWidget {
  final ReadingOverviewEntity overview;

  const DurationTile({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.border),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.hourglass_bottom,
                  size: AppSpacing.lg,
                  color: AppColors.goldAccent,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  AppStrings.durationLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.goldAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.durationDays(overview.daysSinceFirstMark),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
