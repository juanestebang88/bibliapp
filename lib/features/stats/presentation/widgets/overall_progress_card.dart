import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/core/widgets/progress_ring.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/widgets/percent_skeleton.dart';

/// Top card: big donut with the overall percent at the center (spec 19).
/// While a tab switch recalculates, the center shows a shimmer skeleton and
/// the ring keeps the previous progress (spec 22).
class OverallProgressCard extends StatelessWidget {
  final ReadingOverviewEntity overview;
  final bool isSwitchingTab;

  const OverallProgressCard({
    super.key,
    required this.overview,
    this.isSwitchingTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ProgressRing(
        progress: overview.overallProgress,
        size: AppStatsTokens.overallRingSize,
        strokeWidth: AppStatsTokens.overallRingStrokeWidth,
        child: isSwitchingTab
            ? const PercentSkeleton()
            : Text(
                AppStrings.percentOneDecimal(overview.overallProgress * 100),
                style: theme.textTheme.titleLarge,
              ),
      ),
    );
  }
}
