import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_home_tokens.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';

/// Card with the row of the last 5 days: oldest on the left, today on the
/// right. Purely visual indicator — days are not tappable.
class ReadingDaysCard extends StatelessWidget {
  final List<ReadingDayEntity> readingDays;

  const ReadingDaysCard({super.key, required this.readingDays});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayKey = readingDays.isEmpty ? '' : readingDays.last.date;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.border),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final day in readingDays)
              _ReadingDayIndicator(
                label: _labelFor(day.date, todayKey),
                hasRead: day.hasRead,
              ),
          ],
        ),
      ),
    );
  }

  String _labelFor(String dateKey, String todayKey) {
    if (dateKey == todayKey) return AppStrings.today;
    final weekday = DateTime.tryParse(dateKey)?.weekday;
    if (weekday == null) return '';
    return AppStrings.shortDayName(weekday);
  }
}

class _ReadingDayIndicator extends StatelessWidget {
  final String label;
  final bool hasRead;

  const _ReadingDayIndicator({required this.label, required this.hasRead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: AppHomeTokens.readingDotSize,
          height: AppHomeTokens.readingDotSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasRead ? AppColors.greenAccent : AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}
