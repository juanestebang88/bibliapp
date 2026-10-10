import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_reference.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

class ChapterTurnPage extends StatelessWidget {
  final ReadingState state;
  final ChapterReference? reference;

  const ChapterTurnPage({
    super.key,
    required this.state,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = reference != null;
    final book = reference?.book ?? state.currentBook;
    final chapter = reference?.chapter ?? state.currentChapter;
    final passage =
        '${AppStrings.bookName(book)} ${AppStrings.chapter(chapter)}';

    return Container(
      color: theme.colorScheme.surface.withValues(
        alpha: available ? 0.6 : 0.35,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: AppSpacing.xxl,
              color: theme.colorScheme.primary.withValues(
                alpha: available ? 1 : 0.4,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                passage,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary.withValues(
                    alpha: available ? 1 : 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
