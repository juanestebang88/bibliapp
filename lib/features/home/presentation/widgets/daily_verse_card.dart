import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';

/// Daily verse card: pure display, not tappable and with no share action.
class DailyVerseCard extends StatelessWidget {
  final DailyVerseEntity dailyVerse;

  const DailyVerseCard({super.key, required this.dailyVerse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.border),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.dailyVerseLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(dailyVerse.text, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.verseReference(
                dailyVerse.book,
                dailyVerse.chapter,
                dailyVerse.verse,
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
