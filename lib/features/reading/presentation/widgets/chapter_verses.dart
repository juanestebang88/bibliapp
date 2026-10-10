import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

class ChapterVerses extends StatelessWidget {
  final ReadingState state;
  final bool selectable;

  const ChapterVerses({super.key, required this.state, this.selectable = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<ReadingCubit>();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      itemCount: state.chapterVerses.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final verse = state.chapterVerses[index];
        final isSelected = verse.verse == state.currentVerseNumber;
        final numberStyle = theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontSize: state.fontSize,
          fontWeight: isSelected ? FontWeight.bold : null,
        );
        final textStyle = theme.textTheme.bodyLarge?.copyWith(
          fontSize: state.fontSize,
        );

        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.border),
          onTap: selectable ? () => cubit.selectVerse(verse.verse) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${verse.verse} ', style: numberStyle),
                  TextSpan(text: verse.text, style: textStyle),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
