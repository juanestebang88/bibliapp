/// Sizes for the stats screen pieces (spec 19).
class AppStatsTokens {
  const AppStatsTokens._();

  /// Big donut at the top of the screen.
  static const double overallRingSize = 132;

  /// Ring thickness of the big donut.
  static const double overallRingStrokeWidth = 10;

  /// Mini donut inside each book card.
  static const double miniRingSize = 40;

  /// Ring thickness of the mini donut.
  static const double miniRingStrokeWidth = 4;

  /// Height of the chapters-per-day line chart.
  static const double chartHeight = 160;

  /// Polyline thickness of the line chart.
  static const double chartLineWidth = 2;

  /// Radius of the chart nodes (dots).
  static const double chartNodeRadius = 3;

  /// Radius of the zero-value chart nodes.
  static const double chartEmptyNodeRadius = 1.5;

  /// Height of the per-book chart inside the bottom sheet.
  static const double sheetChartHeight = 120;

  /// Horizontal inset of the chart plot area (room for Y labels).
  static const double chartHorizontalInset = 32;

  /// Bottom inset of the chart plot area (room for X labels).
  static const double chartBottomInset = 20;

  /// Top inset of the chart plot area (room for the topmost node).
  static const double chartTopInset = 8;
}
