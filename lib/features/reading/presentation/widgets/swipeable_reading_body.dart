import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_turn_page.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_body.dart';
import 'package:bibliapp/features/reading/presentation/widgets/verses_page.dart';

class SwipeableReadingBody extends StatefulWidget {
  final ReadingState state;

  const SwipeableReadingBody({super.key, required this.state});

  @override
  State<SwipeableReadingBody> createState() => _SwipeableReadingBodyState();
}

class _SwipeableReadingBodyState extends State<SwipeableReadingBody> {
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
  void didUpdateWidget(covariant SwipeableReadingBody oldWidget) {
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
                  ? ChapterTurnPage(
                      state: state,
                      reference: state.previousChapterReference,
                    )
                  : VersesPage(
                      state: state,
                      verses: state.previousChapterVerses,
                    );
            case _currentPageIndex:
              return ReadingBody(state: state);
            default:
              return state.nextChapterVerses.isEmpty
                  ? ChapterTurnPage(
                      state: state,
                      reference: state.nextChapterReference,
                    )
                  : VersesPage(state: state, verses: state.nextChapterVerses);
          }
        },
      ),
    );
  }
}
