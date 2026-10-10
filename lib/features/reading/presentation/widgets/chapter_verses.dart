import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_verse_item.dart';

class ChapterVerses extends StatefulWidget {
  final ReadingState state;
  final bool selectable;

  const ChapterVerses({super.key, required this.state, this.selectable = true});

  @override
  State<ChapterVerses> createState() => _ChapterVersesState();
}

class _ChapterVersesState extends State<ChapterVerses>
    with SingleTickerProviderStateMixin {
  static const Duration _blinkDuration = Duration(milliseconds: 2000);
  static const Duration _scrollDuration = Duration(milliseconds: 350);
  static const double _scrollAlignment = 0.3;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();
  late final AnimationController _blinkController;
  late final Animation<double> _blink;
  int? _blinkVerse;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: _blinkDuration,
    );
    _blink = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_blinkController);
    _blinkController.addStatusListener(_onBlinkStatusChanged);
    _schedulePendingScroll();
  }

  @override
  void didUpdateWidget(covariant ChapterVerses oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.pendingScrollVerse != oldWidget.state.pendingScrollVerse) {
      _schedulePendingScroll();
    }
  }

  void _onBlinkStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      setState(() => _blinkVerse = null);
    }
  }

  void _schedulePendingScroll() {
    final target = widget.state.pendingScrollVerse;
    if (target == null) return;
    _blinkVerse = target;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final targetContext = _targetKey.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          duration: _scrollDuration,
          alignment: _scrollAlignment,
          curve: Curves.easeInOut,
        );
      }
      _blinkController.forward(from: 0);
      context.read<ReadingCubit>().consumePendingScroll();
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingCubit>();
    final verses = widget.state.chapterVerses;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int index = 0; index < verses.length; index++)
            Padding(
              key: verses[index].verse == _blinkVerse ? _targetKey : null,
              padding: EdgeInsets.only(
                bottom: index == verses.length - 1 ? 0 : AppSpacing.md,
              ),
              child: ReadingVerseItem(
                verse: verses[index],
                fontSize: widget.state.fontSize,
                isCurrent:
                    verses[index].verse == widget.state.currentVerseNumber,
                selectable: widget.selectable,
                onTap: () => cubit.selectVerse(verses[index].verse),
                highlight: verses[index].verse == _blinkVerse ? _blink : null,
              ),
            ),
        ],
      ),
    );
  }
}
