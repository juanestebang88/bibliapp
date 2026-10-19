import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/core/widgets/progress_ring.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// One book card of the stats grid: book name and 'read/total percent' on
/// the left, mini donut with the individual progress on the right (spec 19).
class BookStatsCard extends StatelessWidget {
  final BookReadingStatsEntity stats;
  final VoidCallback onTap;

  const BookStatsCard({super.key, required this.stats, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (stats.progress * 100).round();
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.border),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.border),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.bookName(stats.book),
                      style: theme.textTheme.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppStrings.bookProgress(
                        stats.completedChapters,
                        stats.totalChapters,
                        percent,
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ProgressRing(
                progress: stats.progress,
                size: AppStatsTokens.miniRingSize,
                strokeWidth: AppStatsTokens.miniRingStrokeWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
