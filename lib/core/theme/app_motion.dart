import 'package:flutter/animation.dart';

class AppMotion {
  const AppMotion._();

  static const Duration chromeDuration = Duration(milliseconds: 250);
  static const Curve chromeCurve = Curves.easeInOut;
  static const Duration chromeIdleDelay = Duration(milliseconds: 900);
  static const double scrollHideThreshold = 24;

  /// Fraction of the reading body width a horizontal drag must travel to change
  /// the chapter.
  static const double chapterSwipeDistanceFraction = 0.25;

  /// Minimum fling velocity (px/s) that changes the chapter even below the
  /// distance threshold.
  static const double chapterSwipeVelocity = 300;

  /// Breathing pulse of the reading progress button when the last verse is
  /// visible (invites the user to tap and confirm the chapter as read).
  static const Duration progressBreathDuration = Duration(milliseconds: 1200);

  /// How long the "chapter read" confirmation pill stays on screen.
  static const Duration progressAvisoDuration = Duration(seconds: 2);

  /// Breathing pulse of the splash logo while the app bootstraps.
  static const Duration splashBreathDuration = Duration(milliseconds: 1200);

  /// Minimum time the splash stays visible so the animation is perceived even
  /// when the initial data import finishes instantly.
  static const Duration splashMinDuration = Duration(milliseconds: 1200);

  /// Minimum time the percentage skeleton stays visible on a tab switch, so
  /// the recalculation is perceived even when the data arrives instantly.
  static const Duration statsTabSkeletonMinDuration = Duration(
    milliseconds: 400,
  );

  /// One cycle of the stats percentage skeleton shimmer.
  static const Duration skeletonShimmerDuration = Duration(milliseconds: 1400);
}
