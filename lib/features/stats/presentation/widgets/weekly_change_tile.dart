import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// 'PROGRESO' tile: chart icon plus the integer percent change of the last
/// rolling week vs the previous one, e.g. '+14% DESDE LA SEMANA PASADA'
/// (spec 19).
class WeeklyChangeTile extends StatelessWidget {
  final ReadingOverviewEntity overview;

  const WeeklyChangeTile({super.key, required this.overview});

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
                  Icons.insights,
                  size: AppSpacing.lg,
                  color: AppColors.goldAccent,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  AppStrings.progressLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.goldAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.weeklyChange(overview.weeklyChangePercent),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
