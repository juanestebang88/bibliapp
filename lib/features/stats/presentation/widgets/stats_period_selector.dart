import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_state.dart';

/// Pill selector for the chart periodicity: SEMANA / MES (spec 19).
class StatsPeriodSelector extends StatelessWidget {
  final StatsPeriod selected;
  final ValueChanged<StatsPeriod> onSelected;

  const StatsPeriodSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.pillBackground,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _selectorOption(
            context,
            theme,
            StatsPeriod.week,
            AppStrings.periodWeek,
          ),
          _selectorOption(
            context,
            theme,
            StatsPeriod.month,
            AppStrings.periodMonth,
          ),
        ],
      ),
    );
  }

  Widget _selectorOption(
    BuildContext context,
    ThemeData theme,
    StatsPeriod period,
    String label,
  ) {
    final isSelected = period == selected;
    return InkWell(
      onTap: () => onSelected(period),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldAccent : null,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}
