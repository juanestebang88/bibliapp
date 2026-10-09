import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_text_styles.dart';
import 'package:bibliapp/core/widgets/navigation_indicator.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReadingCubit, ReadingState>(
        builder: (context, state) => SafeArea(
          child: Column(
            children: [
              _ReadingHeader(state: state),
              _ChapterNavigation(state: state),
              Expanded(child: _ReadingBody(state: state)),
              const _BottomToolbar(),
              const AppNavigationIndicator(
                destinations: [
                  AppNavDestination(
                    route: '/reading',
                    label: AppStrings.readingNavLabel,
                    icon: Icons.menu_book_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadingHeader extends StatelessWidget {
  final ReadingState state;

  const _ReadingHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<ReadingCubit>();
    final passage =
        '${AppStrings.bookName(state.currentBook)} ${state.currentChapter}';

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          passage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: AppTextStyles.passagePickerFontSize,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: state.fontSize <= 14
                    ? null
                    : () => cubit.adjustFontSize(-1),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  minimumSize: const Size(AppSpacing.xxl, AppSpacing.xxl),
                  padding: EdgeInsets.zero,
                ),
                child: const Text('A−'),
              ),
              TextButton(
                onPressed: state.fontSize >= 32
                    ? null
                    : () => cubit.adjustFontSize(1),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  minimumSize: const Size(AppSpacing.xxl, AppSpacing.xxl),
                  padding: EdgeInsets.zero,
                ),
                child: const Text('A+'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChapterNavigation extends StatelessWidget {
  final ReadingState state;

  const _ChapterNavigation({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingCubit>();
    final canNavigate = state.status == ReadingStatus.success;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: AppStrings.previousChapter,
            onPressed: !canNavigate || state.isFirstChapter
                ? null
                : cubit.previousChapter,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: AppStrings.nextChapter,
            onPressed: !canNavigate || state.isLastChapter
                ? null
                : cubit.nextChapter,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _ReadingBody extends StatelessWidget {
  final ReadingState state;

  const _ReadingBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      ReadingStatus.initial ||
      ReadingStatus.loading => const Center(child: CircularProgressIndicator()),
      ReadingStatus.failure => _FailureView(state: state),
      ReadingStatus.success when state.chapterVerses.isEmpty => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            AppStrings.emptyChapter,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      ReadingStatus.success => _ChapterVerses(state: state),
    };
  }
}

class _FailureView extends StatelessWidget {
  final ReadingState state;

  const _FailureView({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? AppStrings.emptyChapter,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.read<ReadingCubit>().loadChapter(
                state.currentBook,
                state.currentChapter,
              ),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterVerses extends StatelessWidget {
  final ReadingState state;

  const _ChapterVerses({required this.state});

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
          fontSize: (state.fontSize * 0.6).clamp(10.0, 14.0),
          fontWeight: isSelected ? FontWeight.bold : null,
        );
        final textStyle = theme.textTheme.bodyLarge?.copyWith(
          fontSize: state.fontSize,
        );

        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.border),
          onTap: () => cubit.selectVerse(verse.verse),
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

class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSpacing.md,
            sigmaY: AppSpacing.md,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ToolbarAction(
                icon: Icons.bookmark_border,
                label: AppStrings.mark,
              ),
              _ToolbarAction(
                icon: Icons.note_alt_outlined,
                label: AppStrings.notes,
              ),
              _ToolbarAction(
                icon: Icons.share_outlined,
                label: AppStrings.share,
              ),
              _ToolbarAction(icon: Icons.tune, label: AppStrings.settings),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ToolbarAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary;
    return Tooltip(
      message: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.xl, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
