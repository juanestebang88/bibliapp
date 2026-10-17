import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_splash_tokens.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_state.dart';

/// Reading card: continues at the chapter after the last completed one (or
/// at the partial chapter when it is the most recent mark).
class ContinueReadingCard extends StatelessWidget {
  final HomeState state;

  const ContinueReadingCard({super.key, required this.state});

  String _readingRoute() {
    final location = state.continueLocation;
    if (location == null || state.bookCompleted) {
      return '/reading';
    }
    final locationPart = location.isPartial
        ? '&verse=${location.lastVerseRead}'
        : '';
    return '/reading?book=${location.book}&chapter=${location.chapter}'
        '$locationPart';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookName = AppStrings.bookName(state.continueBook);
    final chapterCount = state.chapterCount;
    final progress = chapterCount <= 0
        ? 0.0
        : (state.chaptersCompleted / chapterCount).clamp(0.0, 1.0);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.border),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.readingLocationTitle(
                      state.continueBook,
                      state.continueChapter,
                    ),
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.chaptersReadSummary(
                    state.chaptersCompleted,
                    chapterCount,
                  ),
                  style: theme.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(
              minHeight: AppSplashTokens.progressThickness,
              value: progress,
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              state.bookCompleted
                  ? AppStrings.bookCompleted(bookName)
                  : AppStrings.remainingChapters(
                      state.remainingChapters,
                      bookName,
                    ),
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go(_readingRoute()),
                style: FilledButton.styleFrom(
                  textStyle: theme.textTheme.titleMedium,
                ),
                child: const Text(AppStrings.continueReading),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
