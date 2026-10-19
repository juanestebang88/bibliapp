import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// 'AYER VS HOY' card: header with an icon and both day counters
/// ('CAPÍTULOS AYER [X]' vs '[Y] CAPÍTULOS HOY') (spec 19).
class ChaptersTodayVsYesterdayCard extends StatelessWidget {
  final ReadingOverviewEntity overview;

  const ChaptersTodayVsYesterdayCard({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.border),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.today_outlined,
                  size: AppSpacing.lg,
                  color: AppColors.goldAccent,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  AppStrings.yesterdayVsToday,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.goldAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.chaptersYesterday(overview.chaptersYesterday),
                  style: theme.textTheme.labelMedium,
                ),
                Text(
                  AppStrings.chaptersToday(overview.chaptersToday),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.goldAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
