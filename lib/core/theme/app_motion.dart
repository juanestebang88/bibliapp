import 'package:flutter/animation.dart';

class AppMotion {
  const AppMotion._();

  static const Duration chromeDuration = Duration(milliseconds: 250);
  static const Curve chromeCurve = Curves.easeInOut;
  static const Duration chromeIdleDelay = Duration(seconds: 3);
  static const double scrollHideThreshold = 24;
}
