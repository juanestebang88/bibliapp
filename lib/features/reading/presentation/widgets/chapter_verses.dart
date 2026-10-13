import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_verse_item.dart';

class ChapterVerses extends StatefulWidget {
  final ReadingState state;

  /// Reports the last verse number whose bottom edge is inside the viewport.
  final ValueChanged<int>? onVisibleVerseChanged;

  /// Extra trailing room appended below the last verse, used to keep it clear
  /// of the floating progress button at the bottom of the chapter.
  final double bottomContentInset;

  const ChapterVerses({
    super.key,
    required this.state,
    this.onVisibleVerseChanged,
    this.bottomContentInset = 0,
  });

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
  final GlobalKey _scrollViewKey = GlobalKey();
  final List<GlobalKey> _verseKeys = <GlobalKey>[];
  late final AnimationController _blinkController;
  late final Animation<double> _blink;
  int? _blinkVerse;
  int? _lastVisibleVerse;

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
    final chapterChanged =
        oldWidget.state.currentBook != widget.state.currentBook ||
        oldWidget.state.currentChapter != widget.state.currentChapter;
    final fontSizeChanged = oldWidget.state.fontSize != widget.state.fontSize;
    if (chapterChanged || fontSizeChanged) {
      _lastVisibleVerse = null;
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

  /// Computes the last verse whose bottom edge is inside the viewport and
  /// reports it without rebuilding this widget. Only runs on scroll, so a
  /// freshly loaded chapter starts at 0 % until the user (or a programmatic
  /// jump) moves the viewport.
  void _updateVisibleVerse() {
    final verses = widget.state.chapterVerses;
    final viewportBox =
        _scrollViewKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewportBox == null || verses.isEmpty) return;

    // Back at the very top the chapter counts as "not started" again, so the
    // progress button returns to 0 % until the reader scrolls down once more.
    final atTop =
        _scrollController.hasClients &&
        _scrollController.offset <= _scrollController.position.minScrollExtent;

    final viewportTop = viewportBox.localToGlobal(Offset.zero).dy;
    final viewportBottom = viewportTop + viewportBox.size.height;

    int? visible;
    if (!atTop) {
      for (int index = 0; index < verses.length; index++) {
        final box =
            _verseKeys[index].currentContext?.findRenderObject() as RenderBox?;
        if (box == null) continue;
        final bottom = box.localToGlobal(Offset(0, box.size.height)).dy;
        if (bottom <= viewportBottom) {
          visible = verses[index].verse;
        } else {
          break;
        }
      }
    }

    final reported = atTop ? 0 : visible;
    if (reported != null && reported != _lastVisibleVerse) {
      _lastVisibleVerse = reported;
      widget.onVisibleVerseChanged?.call(reported);
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verses = widget.state.chapterVerses;

    if (_verseKeys.length != verses.length) {
      _verseKeys
        ..clear()
        ..addAll(List.generate(verses.length, (_) => GlobalKey()));
      _lastVisibleVerse = null;
    }

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        _updateVisibleVerse();
        return false;
      },
      child: SingleChildScrollView(
        key: _scrollViewKey,
        controller: _scrollController,
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.md,
          bottom: AppSpacing.md + widget.bottomContentInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int index = 0; index < verses.length; index++)
              KeyedSubtree(
                key: _verseKeys[index],
                child: Padding(
                  key: verses[index].verse == _blinkVerse ? _targetKey : null,
                  padding: EdgeInsets.only(
                    bottom: index == verses.length - 1 ? 0 : AppSpacing.md,
                  ),
                  child: ReadingVerseItem(
                    verse: verses[index],
                    fontSize: widget.state.fontSize,
                    highlight: verses[index].verse == _blinkVerse
                        ? _blink
                        : null,
                    highlights: widget.state.chapterHighlights
                        .where(
                          (highlight) => highlight.verse == verses[index].verse,
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
