import 'package:flutter/animation.dart';

class AppMotion {
  const AppMotion._();

  static const Duration chromeDuration = Duration(milliseconds: 250);
  static const Curve chromeCurve = Curves.easeInOut;
  static const Duration chromeIdleDelay = Duration(milliseconds: 1800);
  static const double scrollHideThreshold = 24;

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
}
