import 'package:bibliapp/core/theme/app_spacing.dart';

/// Tokens for the verse selection context menu (spec 11).
class AppContextMenuTokens {
  const AppContextMenuTokens._();

  /// Elevation of the floating toolbar surface.
  static const double elevation = 8;

  /// Minimum distance kept between the toolbar and the screen edges.
  static const double screenPadding = AppSpacing.sm;

  /// Vertical gap between the anchor (the selected text) and the toolbar.
  static const double anchorGap = AppSpacing.sm;

  /// Maximum width of the two-column action grid.
  static const double maxWidth = 420;

  /// Size of the leading icon shown next to each action label.
  static const double iconSize = 18;

  /// Gap between an action icon and its label.
  static const double iconGap = AppSpacing.sm;
}
