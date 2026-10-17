import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_body.dart';

/// Hosts the reading body and turns a horizontal swipe into chapter navigation:
/// dragging left loads the next chapter and dragging right the previous one.
/// A swipe counts either by distance (a fraction of the body width) or by a
/// fast fling velocity, so both slow and quick gestures work.
///
/// Raw pointer events are tracked with a [Listener] instead of a competing
/// [GestureDetector]: the verse text uses `SelectableText`, whose internal
/// gesture detector eagerly wins horizontal drags on Android and would swallow
/// the swipe. A [Listener] observes pointer events without joining the gesture
/// arena, so long-press text selection keeps working untouched.
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
  Timer? _longPressTimer;
  bool _tracking = false;
  bool _cancelled = false;
  bool _horizontal = false;
  double _horizontalDistance = 0;
  double _verticalDistance = 0;
  double _velocity = 0;
  Duration _lastMoveTime = Duration.zero;

  void _onPointerDown(PointerDownEvent event) {
    if (_tracking) {
      // A second pointer means a multi-touch gesture: ignore the sequence.
      _cancelled = true;
      return;
    }
    _tracking = true;
    _cancelled = false;
    _horizontal = false;
    _horizontalDistance = 0;
    _verticalDistance = 0;
    _velocity = 0;
    _lastMoveTime = event.timeStamp;
    // A hold that turns into a drag is a text-selection gesture, not a swipe.
    _longPressTimer = Timer(kLongPressTimeout, () => _cancelled = true);
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_tracking || _cancelled) return;

    final delta = event.delta;
    _horizontalDistance += delta.dx;
    _verticalDistance += delta.dy;

    final elapsed = event.timeStamp - _lastMoveTime;
    if (elapsed > Duration.zero) {
      _velocity = delta.dx / (elapsed.inMicroseconds / 1000000);
      _lastMoveTime = event.timeStamp;
    }

    if (!_horizontal &&
        _horizontalDistance.abs() > kTouchSlop &&
        _horizontalDistance.abs() > _verticalDistance.abs()) {
      _horizontal = true;
    }
  }

  void _onPointerUp(PointerUpEvent event) => _finish();

  void _onPointerCancel(PointerCancelEvent event) => _reset();

  void _finish() {
    final wasTracking = _tracking;
    final cancelled = _cancelled;
    final horizontal = _horizontal;
    final distance = _horizontalDistance;
    final velocity = _velocity;
    _reset();

    if (!wasTracking || cancelled || !horizontal) return;
    if (widget.state.status != ReadingStatus.success) return;
    if (widget.state.chapterVerses.isEmpty) return;

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

  void _reset() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _tracking = false;
    _cancelled = false;
    _horizontal = false;
    _horizontalDistance = 0;
    _verticalDistance = 0;
    _velocity = 0;
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: ReadingBody(
        state: widget.state,
        onVisibleVerseChanged: widget.onVisibleVerseChanged,
        bottomContentInset: widget.bottomContentInset,
      ),
    );
  }
}
