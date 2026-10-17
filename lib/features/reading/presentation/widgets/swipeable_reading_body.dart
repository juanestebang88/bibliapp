import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_body.dart';

/// Hosts the reading body and turns a horizontal swipe into chapter navigation:
/// dragging left loads the next chapter and dragging right the previous one.
/// A swipe counts either by distance (a fraction of the body width) or by a
/// fast fling velocity, so both slow and quick gestures work.
class SwipeableReadingBody extends StatefulWidget {
  final ReadingState state;

  /// Reports the last verse number visible inside the viewport.
  final ValueChanged<int>? onVisibleVerseChanged;

  /// Extra trailing room in the scrollable content, used to keep the last
  /// verse clear of the floating progress button.
  final double bottomContentInset;

  const SwipeableReadingBody({
    super.key,
    required this.state,
    this.onVisibleVerseChanged,
    this.bottomContentInset = 0,
  });

  @override
  State<SwipeableReadingBody> createState() => _SwipeableReadingBodyState();
}

class _SwipeableReadingBodyState extends State<SwipeableReadingBody> {
  /// Horizontal travel accumulated during the current drag; negative is left.
  double _dragDistance = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.primaryDelta ?? 0;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final distance = _dragDistance;
    final velocity = details.primaryVelocity ?? 0;
    _dragDistance = 0;

    if (widget.state.status != ReadingStatus.success) return;

    final width = context.size?.width ?? 0;
    final distanceThreshold = width * AppMotion.chapterSwipeDistanceFraction;
    final passedDistance =
        distanceThreshold > 0 && distance.abs() >= distanceThreshold;
    final passedVelocity = velocity.abs() >= AppMotion.chapterSwipeVelocity;
    if (!passedDistance && !passedVelocity) return;

    final cubit = context.read<ReadingCubit>();
    final direction = passedDistance ? distance : velocity;
    if (direction < 0) {
      cubit.nextChapter();
    } else {
      cubit.previousChapter();
    }
  }

  void _onHorizontalDragCancel() {
    _dragDistance = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onHorizontalDragCancel: _onHorizontalDragCancel,
      child: ReadingBody(
        state: widget.state,
        onVisibleVerseChanged: widget.onVisibleVerseChanged,
        bottomContentInset: widget.bottomContentInset,
      ),
    );
  }
}
