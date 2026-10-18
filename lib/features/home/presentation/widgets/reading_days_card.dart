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
    final todayKey = readingDays.isEmpty ? '' : readingDays.last.date;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.border),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final day in readingDays)
              _ReadingDayIndicator(
                label: _labelFor(day.date, todayKey),
                status: _statusFor(day, day.date == todayKey),
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

  _ReadingDayStatus _statusFor(ReadingDayEntity day, bool isToday) {
    if (day.hasRead) return _ReadingDayStatus.read;
    if (isToday) return _ReadingDayStatus.noDataToday;
    return _ReadingDayStatus.notRead;
  }
}

enum _ReadingDayStatus { read, noDataToday, notRead }

class _ReadingDayIndicator extends StatelessWidget {
  final String label;
  final _ReadingDayStatus status;

  const _ReadingDayIndicator({required this.label, required this.status});

  IconData get _glyph {
    switch (status) {
      case _ReadingDayStatus.read:
        return Icons.check;
      case _ReadingDayStatus.noDataToday:
        return Icons.remove;
      case _ReadingDayStatus.notRead:
        return Icons.close;
    }
  }

  Color get _glyphColor {
    switch (status) {
      case _ReadingDayStatus.read:
        return AppColors.greenAccent;
      case _ReadingDayStatus.noDataToday:
        return AppColors.secondaryText;
      case _ReadingDayStatus.notRead:
        return AppColors.noReadingRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: AppHomeTokens.readingDayCircleSize,
          height: AppHomeTokens.readingDayCircleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _glyphColor.withValues(alpha: 0.45)),
            ),
            child: Icon(
              _glyph,
              size: AppHomeTokens.readingDayIconSize,
              color: _glyphColor,
            ),
          ),
        ),
      ],
    );
  }
}
