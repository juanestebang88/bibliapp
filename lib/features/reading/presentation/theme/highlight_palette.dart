import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:flutter/material.dart';

/// Visual tokens for user verse highlights (spec 11).
///
/// Maps the domain [HighlightColor] to the theme colors and exposes the shared
/// alpha/thickness values used when rendering highlights.
class HighlightPalette {
  const HighlightPalette._();

  static const double backgroundAlpha = 0.28;
  static const double borderWidth = 1;

  static const List<HighlightColor> ordered = HighlightColor.values;

  static Color base(HighlightColor color) => switch (color) {
    HighlightColor.green => AppColors.highlightGreen,
    HighlightColor.blue => AppColors.highlightBlue,
    HighlightColor.yellow => AppColors.highlightYellow,
    HighlightColor.copper => AppColors.highlightCopper,
  };

  static Color background(HighlightColor color) =>
      base(color).withValues(alpha: backgroundAlpha);
}
