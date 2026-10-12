import 'package:bibliapp/core/theme/app_spacing.dart';

/// Tokens for the floating reading progress button (spec 08).
class AppProgressButtonTokens {
  const AppProgressButtonTokens._();

  static const double defaultOpacity = 0.8;
  static const double diameter = 56;
  static const double ringThickness = 3;

  /// Bottom margin used to lift the button above the chapter navigation.
  static const double bottomMargin = AppSpacing.md;

  /// Extra trailing room appended to the chapter content so the last verse
  /// stays clear of the floating button once the chapter is scrolled to the end.
  static const double contentBottomClearance =
      (diameter + bottomMargin + AppSpacing.xl) * 0.75;
}
