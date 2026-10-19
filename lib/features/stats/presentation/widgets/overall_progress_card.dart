import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/core/widgets/progress_ring.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// Top card: big donut with the overall percent at the center (spec 19).
class OverallProgressCard extends StatelessWidget {
  final ReadingOverviewEntity overview;

  const OverallProgressCard({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ProgressRing(
        progress: overview.overallProgress,
        size: AppStatsTokens.overallRingSize,
        strokeWidth: AppStatsTokens.overallRingStrokeWidth,
        child: Text(
          AppStrings.percentOneDecimal(overview.overallProgress * 100),
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
