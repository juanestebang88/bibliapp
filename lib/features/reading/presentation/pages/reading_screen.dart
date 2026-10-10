import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_text_styles.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_reference.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
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
              Expanded(child: _SwipeableReadingBody(state: state)),
              const _BottomToolbar(),
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
                  foregroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(AppSpacing.xxl, AppSpacing.xxl),
                  padding: EdgeInsets.zero,
                ),
                child: Text('A−', style: AppTextStyles.labelAMinus),
              ),
              TextButton(
                onPressed: state.fontSize >= 32
                    ? null
                    : () => cubit.adjustFontSize(1),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(AppSpacing.xxl, AppSpacing.xxl),
                  padding: EdgeInsets.zero,
                ),
                child: Text('A+', style: AppTextStyles.labelAPlus),
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
    final previousReference = state.previousChapterReference;
    final nextReference = state.nextChapterReference;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _ChapterNavButton(
              icon: Icons.chevron_left,
              label: previousReference == null
                  ? AppStrings.previous
                  : _referenceLabel(previousReference),
              enabled: canNavigate && previousReference != null,
              tooltip: AppStrings.previousChapter,
              onTap: cubit.previousChapter,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _ChapterNavButton(
              icon: Icons.chevron_right,
              label: nextReference == null
                  ? AppStrings.next
                  : _referenceLabel(nextReference),
              enabled: canNavigate && nextReference != null,
              tooltip: AppStrings.nextChapter,
              iconLeading: false,
              onTap: cubit.nextChapter,
            ),
          ),
        ],
      ),
    );
  }

  String _referenceLabel(ChapterReference reference) {
    if (reference.book == state.currentBook) {
      return AppStrings.chapter(reference.chapter);
    }
    return '${AppStrings.bookName(reference.book)} ${reference.chapter}';
  }
}

class _ChapterNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final bool enabled;
  final bool iconLeading;
  final VoidCallback onTap;

  const _ChapterNavButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
    this.iconLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.3);
    final borderRadius = BorderRadius.circular(AppRadius.pill);

    return Tooltip(
      message: tooltip,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSpacing.md,
            sigmaY: AppSpacing.md,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.1),
              borderRadius: borderRadius,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(
                  alpha: enabled ? 0.15 : 0.15,
                ),
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color.fromARGB(
                      255,
                      50,
                      45,
                      45,
                    ).withValues(alpha: enabled ? 0.16 : 0.05),
                    Colors.white.withValues(alpha: enabled ? 0.03 : 0.01),
                  ],
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: enabled ? onTap : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (iconLeading) ...[
                          Icon(icon, size: AppSpacing.xl, color: foreground),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: foreground,
                            ),
                          ),
                        ),
                        if (!iconLeading) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Icon(icon, size: AppSpacing.xl, color: foreground),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeableReadingBody extends StatefulWidget {
  final ReadingState state;

  const _SwipeableReadingBody({required this.state});

  @override
  State<_SwipeableReadingBody> createState() => _SwipeableReadingBodyState();
}

class _SwipeableReadingBodyState extends State<_SwipeableReadingBody> {
  static const int _currentPageIndex = 1;
  static const int _pageCount = 3;
  static const Duration _bounceDuration = Duration(milliseconds: 250);

  final PageController _pageController = PageController(
    initialPage: _currentPageIndex,
  );
  late ReadingState _displayState;

  @override
  void initState() {
    super.initState();
    _displayState = widget.state;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _SwipeableReadingBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.state;
    final current = widget.state;
    if (previous == current) return;

    final chapterChanged =
        previous.currentBook != current.currentBook ||
        previous.currentChapter != current.currentChapter;

    if (!chapterChanged || _isCentered) {
      _displayState = current;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _pageController.jumpToPage(_currentPageIndex);
      setState(() => _displayState = widget.state);
    });
  }

  bool get _isCentered =>
      (_pageController.hasClients
              ? _pageController.page ?? _currentPageIndex.toDouble()
              : _currentPageIndex.toDouble())
          .round() ==
      _currentPageIndex;

  bool _handleScrollEnd(ScrollEndNotification notification) {
    if (notification.metrics.axis != Axis.horizontal) return false;

    final settled = _pageController.page?.round() ?? _currentPageIndex;
    if (settled == _currentPageIndex) return false;

    final goingBackward = settled < _currentPageIndex;
    final state = _displayState;
    final neighborExists = goingBackward
        ? state.previousChapterReference != null
        : state.nextChapterReference != null;

    if (!neighborExists) {
      _pageController.animateToPage(
        _currentPageIndex,
        duration: _bounceDuration,
        curve: Curves.easeOutCubic,
      );
      return false;
    }

    final cubit = context.read<ReadingCubit>();
    if (goingBackward) {
      cubit.previousChapter();
    } else {
      cubit.nextChapter();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = _displayState;

    return NotificationListener<ScrollEndNotification>(
      onNotification: _handleScrollEnd,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _pageCount,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return state.previousChapterVerses.isEmpty
                  ? _ChapterTurnPage(
                      state: state,
                      reference: state.previousChapterReference,
                    )
                  : _VersesPage(
                      state: state,
                      verses: state.previousChapterVerses,
                    );
            case _currentPageIndex:
              return _ReadingBody(state: state);
            default:
              return state.nextChapterVerses.isEmpty
                  ? _ChapterTurnPage(
                      state: state,
                      reference: state.nextChapterReference,
                    )
                  : _VersesPage(state: state, verses: state.nextChapterVerses);
          }
        },
      ),
    );
  }
}

class _VersesPage extends StatelessWidget {
  final ReadingState state;
  final List<VerseEntity> verses;

  const _VersesPage({required this.state, required this.verses});

  @override
  Widget build(BuildContext context) {
    return _ChapterVerses(
      state: state.copyWith(chapterVerses: verses, currentVerseNumber: 1),
      selectable: false,
    );
  }
}

class _ChapterTurnPage extends StatelessWidget {
  final ReadingState state;
  final ChapterReference? reference;

  const _ChapterTurnPage({required this.state, required this.reference});

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
  final bool selectable;

  const _ChapterVerses({required this.state, this.selectable = true});

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

class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppRadius.pill);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSpacing.md,
            sigmaY: AppSpacing.md,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.8),
              borderRadius: borderRadius,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ToolbarAction(
                      icon: Icons.home_outlined,
                      label: AppStrings.home,
                    ),
                    _ToolbarAction(
                      icon: Icons.menu_book_outlined,
                      label: AppStrings.reading,
                    ),
                    _ToolbarAction(
                      icon: Icons.bar_chart,
                      label: AppStrings.statistics,
                    ),
                    _ToolbarAction(
                      icon: Icons.settings_outlined,
                      label: AppStrings.settings,
                    ),
                  ],
                ),
              ),
            ),
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
          Icon(icon, size: AppSpacing.xxl, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
