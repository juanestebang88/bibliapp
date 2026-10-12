import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/core/theme/app_progress_button_tokens.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/mark_chapter_read_dialog.dart';

/// Floating circular button that shows the reading progress of the current
/// chapter (last visible verse / total) and resolves taps against the chapter
/// progress state (mark complete, save up to a verse, or unmark).
///
/// The ring interpolates from [AppColors.bronze] to [AppColors.greenAccent] as
/// progress rises, turns fully green at 100 % and gently "breathes" to invite
/// the tap that confirms the chapter as read. Once confirmed it switches to a
/// filled "read" state and shows a brief confirmation pill.
class ReadingProgressButton extends StatefulWidget {
  final ReadingState state;

  /// Live last visible verse reported by [ChapterVerses].
  final ValueNotifier<int> visibleVerse;

  /// Identifies the breathing pulse wrapper (used by tests).
  static const Key breathScaleKey = Key('reading-progress-breath-scale');

  const ReadingProgressButton({
    super.key,
    required this.state,
    required this.visibleVerse,
  });

  @override
  State<ReadingProgressButton> createState() => _ReadingProgressButtonState();
}

class _ReadingProgressButtonState extends State<ReadingProgressButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathOpacity;
  late final Animation<double> _breathScale;

  Timer? _avisoTimer;
  bool _showAviso = false;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppMotion.progressBreathDuration,
    );
    final breathing = CurvedAnimation(
      parent: _breathController,
      curve: AppMotion.chromeCurve,
    );
    _breathOpacity = Tween<double>(begin: 1, end: 0.72).animate(breathing);
    _breathScale = Tween<double>(begin: 1, end: 1.03).animate(breathing);
    widget.visibleVerse.addListener(_syncBreathing);
    _syncBreathing();
  }

  @override
  void didUpdateWidget(covariant ReadingProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visibleVerse != widget.visibleVerse) {
      oldWidget.visibleVerse.removeListener(_syncBreathing);
      widget.visibleVerse.addListener(_syncBreathing);
    }
    _syncBreathing();
  }

  @override
  void dispose() {
    widget.visibleVerse.removeListener(_syncBreathing);
    _avisoTimer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  /// Breathes only once the last verse was actually reached by reading (a
  /// chapters with a single verse never breathes), and stops when the chapter
  /// is already marked as read.
  void _syncBreathing() {
    final total = widget.state.chapterVerses.length;
    final visible = widget.visibleVerse.value;
    final isComplete = widget.state.chapterProgress?.isComplete ?? false;
    final shouldBreathe = !isComplete && visible > 1 && visible >= total;

    if (shouldBreathe) {
      if (!_breathController.isAnimating) {
        _breathController.repeat(reverse: true);
      }
    } else if (_breathController.isAnimating) {
      _breathController.reset();
    }
  }

  Future<void> _onTap() async {
    final total = widget.state.chapterVerses.length;
    if (total == 0) return;

    if (widget.state.chapterProgress?.isComplete ?? false) {
      await _openDialog(complete: true);
      return;
    }

    final visible = widget.visibleVerse.value.clamp(1, total);
    if (visible >= total) {
      await context.read<ReadingCubit>().markChapterComplete();
      if (mounted) _showConfirmation();
      return;
    }

    await _openDialog(initialVerse: visible);
  }

  Future<void> _openDialog({bool complete = false, int? initialVerse}) async {
    final total = widget.state.chapterVerses.length;
    final result = await showDialog<MarkChapterReadResult>(
      context: context,
      builder: (_) => MarkChapterReadDialog(
        totalVerses: total,
        initialVerse: initialVerse ?? widget.visibleVerse.value.clamp(1, total),
        complete: complete,
      ),
    );
    if (result == null || !mounted) return;

    final cubit = context.read<ReadingCubit>();
    switch (result.action) {
      case MarkChapterAction.markComplete:
        await cubit.markChapterComplete();
        if (mounted) _showConfirmation();
      case MarkChapterAction.saveUntilVerse:
        await cubit.savePartialProgress(result.verse);
      case MarkChapterAction.unmark:
        await cubit.unmarkChapter();
    }
  }

  void _showConfirmation() {
    _avisoTimer?.cancel();
    setState(() => _showAviso = true);
    _avisoTimer = Timer(AppMotion.progressAvisoDuration, () {
      if (mounted) setState(() => _showAviso = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.visibleVerse,
      builder: (context, visible, _) {
        final total = widget.state.chapterVerses.length;
        if (total == 0) return const SizedBox.shrink();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: AppMotion.chromeDuration,
              child: _showAviso
                  ? const _ConfirmationPill()
                  : const SizedBox.shrink(),
            ),
            _buildCircle(context, visible: visible, total: total),
          ],
        );
      },
    );
  }

  Widget _buildCircle(
    BuildContext context, {
    required int visible,
    required int total,
  }) {
    final theme = Theme.of(context);
    final isComplete = widget.state.chapterProgress?.isComplete ?? false;
    final progress = (visible / total).clamp(0.0, 1.0);
    final atEnd = visible >= total;
    final accent = Color.lerp(
      theme.colorScheme.secondary,
      AppColors.greenAccent,
      progress,
    )!;

    final Widget circle = isComplete
        ? _buildCompleteCircle(theme)
        : _buildProgressCircle(theme, accent, progress, atEnd);

    return Tooltip(
      message: atEnd && !isComplete
          ? AppStrings.tapToConfirm
          : AppStrings.readingProgressButton,
      child: Opacity(
        opacity: AppProgressButtonTokens.defaultOpacity,
        child: SizedBox(
          width: AppProgressButtonTokens.diameter,
          height: AppProgressButtonTokens.diameter,
          child: circle,
        ),
      ),
    );
  }

  Widget _buildProgressCircle(
    ThemeData theme,
    Color accent,
    double progress,
    bool atEnd,
  ) {
    final style = theme.textTheme.labelSmall?.copyWith(
      color: accent,
      fontWeight: FontWeight.bold,
    );

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.10),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _onTap,
        child: FadeTransition(
          opacity: _breathOpacity,
          child: ScaleTransition(
            key: ReadingProgressButton.breathScaleKey,
            scale: _breathScale,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: AppProgressButtonTokens.ringThickness,
                  color: accent,
                  backgroundColor: accent.withValues(alpha: 0.15),
                ),
                Center(
                  child: atEnd
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: AppSpacing.lg,
                              color: accent,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(AppStrings.percent(100), style: style),
                          ],
                        )
                      : Text(
                          AppStrings.percent((progress * 100).round()),
                          style: style,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteCircle(ThemeData theme) {
    return Material(
      color: AppColors.greenAccent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _onTap,
        child: const Center(
          child: Icon(
            Icons.check,
            size: AppSpacing.lg,
            color: AppColors.offWhite,
          ),
        ),
      ),
    );
  }
}

/// Transient pill that confirms the chapter was marked as read. Its glass look
/// (translucent fill, thin inner ring and warm light text) is the Flutter
/// translation of the bronze highlight used elsewhere; here it is green to
/// match the completed state.
class _ConfirmationPill extends StatelessWidget {
  const _ConfirmationPill();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.greenAccent.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(AppRadius.border),
          border: Border.all(
            color: AppColors.greenLight.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check,
              size: AppSpacing.md,
              color: AppColors.greenLight,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              AppStrings.chapterMarkedComplete,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.greenLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
