import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/core/widgets/progress_ring.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// Top card: big donut with the overall percent at the center and the
/// 'DE LA LISTA DE TODOS LOS LIBROS' caption below (spec 19).
class OverallProgressCard extends StatelessWidget {
  final ReadingOverviewEntity overview;

  const OverallProgressCard({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ProgressRing(
          progress: overview.overallProgress,
          size: AppStatsTokens.overallRingSize,
          strokeWidth: AppStatsTokens.overallRingStrokeWidth,
          child: Text(
            AppStrings.percentOneDecimal(overview.overallProgress * 100),
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.allBooksLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
