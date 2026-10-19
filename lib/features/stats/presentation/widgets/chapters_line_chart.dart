import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// Chapters-per-day line chart drawn with CustomPaint: a horizontal grid line
/// with its number for every integer value from 0 up to the series max, Y
/// labels on the right of the plot area, one node per day and short Spanish
/// day names on the X axis. In month view only every 5th day is labelled to
/// avoid overlap (spec 19). The polyline is traced left to right while a dot
/// travels to the last point; with reduced motion the chart is painted at once
/// (spec 20).
class ChaptersLineChart extends StatelessWidget {
  final List<ChaptersSeriesPointEntity> points;
  final double height;

  const ChaptersLineChart({
    super.key,
    required this.points,
    this.height = AppStatsTokens.chartHeight,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget chart(double progress) => SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ChaptersLinePainter(
          points: points,
          textTheme: textTheme,
          progress: progress,
        ),
      ),
    );

    if (points.isEmpty || MediaQuery.of(context).disableAnimations) {
      return chart(1);
    }

    return TweenAnimationBuilder<double>(
      // Restart the reveal whenever the series changes (period, tab or book).
      key: ValueKey(
        points.map((point) => '${point.date}:${point.chaptersCount}').join('|'),
      ),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(
        milliseconds: AppStatsTokens.chartAnimationDurationMs,
      ),
      curve: Curves.easeInOut,
      builder: (context, progress, _) => chart(progress),
    );
  }
}

class _ChaptersLinePainter extends CustomPainter {
  final List<ChaptersSeriesPointEntity> points;
  final TextTheme textTheme;
  final double progress;

  _ChaptersLinePainter({
    required this.points,
    required this.textTheme,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final plotLeft = AppStatsTokens.chartLeftInset;
    final plotRight = size.width - AppStatsTokens.chartRightInset;
    final plotTop = AppStatsTokens.chartTopInset;
    final plotBottom = size.height - AppStatsTokens.chartBottomInset;
    final plotHeight = plotBottom - plotTop;

    final maxCount = points.fold<int>(
      0,
      (max, point) => math.max(max, point.chaptersCount),
    );
    // Avoid dividing by zero on all-zero series.
    final maxValue = maxCount > 0 ? maxCount.toDouble() : 1.0;
    final axisStyle = textTheme.labelSmall?.copyWith(
      color: AppColors.secondaryText,
    );

    _drawGrid(
      canvas,
      left: plotLeft,
      right: plotRight,
      top: plotTop,
      bottom: plotBottom,
      maxCount: maxCount,
      maxValue: maxValue,
      style: axisStyle,
    );

    double yFor(int value) => plotBottom - value / maxValue * plotHeight;
    double xFor(int index) =>
        plotLeft + index * (plotRight - plotLeft) / (points.length - 1);

    if (points.length == 1) {
      final center = Offset(
        (plotLeft + plotRight) / 2,
        yFor(points.first.chaptersCount),
      );
      _drawNode(canvas, center, points.first.chaptersCount > 0);
      _drawXLabel(canvas, points.first.date, center.dx, plotBottom, axisStyle);
      return;
    }

    final positions = [
      for (var index = 0; index < points.length; index++)
        Offset(xFor(index), yFor(points[index].chaptersCount)),
    ];

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppStatsTokens.chartLineWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.goldAccent;

    final path = Path()..moveTo(positions.first.dx, positions.first.dy);
    for (var index = 1; index < positions.length; index++) {
      path.lineTo(positions[index].dx, positions[index].dy);
    }

    final metric = path.computeMetrics().first;
    final drawnLength = metric.length * progress.clamp(0.0, 1.0);
    if (drawnLength > 0) {
      canvas.drawPath(metric.extractPath(0, drawnLength), linePaint);
    }

    final tip = metric.getTangentForOffset(drawnLength)?.position;
    final revealedX = tip?.dx ?? positions.first.dx;
    for (var index = 0; index < positions.length; index++) {
      if (positions[index].dx > revealedX + 0.5) break;
      _drawNode(canvas, positions[index], points[index].chaptersCount > 0);
      final shouldLabel = points.length <= 7 || index % 5 == 0;
      if (shouldLabel) {
        _drawXLabel(
          canvas,
          points[index].date,
          positions[index].dx,
          plotBottom,
          axisStyle,
        );
      }
    }

    // Travelling dot that walks the line until the last value.
    if (tip != null && progress < 1) {
      canvas.drawCircle(
        tip,
        AppStatsTokens.chartNodeRadius + 1,
        Paint()..color = AppColors.goldLight,
      );
    }
  }

  /// Horizontal line plus right-side number for every integer from 0 to
  /// [maxCount]. When labels would overlap, only every N value is numbered
  /// while every line is kept.
  void _drawGrid(
    Canvas canvas, {
    required double left,
    required double right,
    required double top,
    required double bottom,
    required int maxCount,
    required double maxValue,
    required TextStyle? style,
  }) {
    final gridPaint = Paint()
      ..color = AppColors.secondaryText.withValues(alpha: 0.18)
      ..strokeWidth = AppStatsTokens.chartGridLineWidth;
    final valueSpacing = (bottom - top) / maxValue;
    final labelHeight = _textHeight('0', style);
    final labelStep = valueSpacing <= 0 || labelHeight <= 0
        ? 1
        : math.max(1, (labelHeight / valueSpacing).ceil());

    for (var value = 0; value <= maxCount; value++) {
      final y = bottom - value / maxValue * (bottom - top);
      canvas.drawLine(Offset(left, y), Offset(right, y), gridPaint);
      if (value % labelStep == 0) {
        _drawYLabel(canvas, '$value', Offset(right, y), style);
      }
    }
  }

  void _drawNode(Canvas canvas, Offset center, bool hasData) {
    final nodePaint = Paint()
      ..color = hasData ? AppColors.goldAccent : AppColors.secondaryText;
    canvas.drawCircle(
      center,
      hasData
          ? AppStatsTokens.chartNodeRadius
          : AppStatsTokens.chartEmptyNodeRadius,
      nodePaint,
    );
  }

  void _drawXLabel(
    Canvas canvas,
    String dateKey,
    double centerX,
    double baselineY,
    TextStyle? style,
  ) {
    final date = DateTime.tryParse(dateKey);
    if (date == null) return;
    _drawAxisLabel(
      canvas,
      AppStrings.shortDayName(date.weekday),
      Offset(centerX, baselineY),
      style,
      alignCenter: true,
      above: false,
    );
  }

  /// Number drawn to the right of the plot area, vertically centered on its
  /// grid line.
  void _drawYLabel(
    Canvas canvas,
    String text,
    Offset anchor,
    TextStyle? style,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(anchor.dx + AppSpacing.xs, anchor.dy - textPainter.height / 2),
    );
  }

  void _drawAxisLabel(
    Canvas canvas,
    String text,
    Offset anchor,
    TextStyle? style, {
    bool alignCenter = false,
    bool above = true,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final offsetX = alignCenter ? -textPainter.width / 2 : -textPainter.width;
    final offsetY = above ? -textPainter.height : AppSpacing.xs;
    textPainter.paint(canvas, anchor.translate(offsetX, offsetY));
  }

  double _textHeight(String text, TextStyle? style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.height;
  }

  @override
  bool shouldRepaint(_ChaptersLinePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.progress != progress;
}
