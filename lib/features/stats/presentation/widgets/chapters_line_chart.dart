import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

/// Chapters-per-day line chart drawn with CustomPaint: one node per day,
/// Y axis in chapters/day, X axis with short Spanish day names. In month
/// view only every 5th day is labelled to avoid overlap (spec 19).
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
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ChaptersLinePainter(
          points: points,
          textTheme: theme.textTheme,
        ),
      ),
    );
  }
}

class _ChaptersLinePainter extends CustomPainter {
  final List<ChaptersSeriesPointEntity> points;
  final TextTheme textTheme;

  _ChaptersLinePainter({required this.points, required this.textTheme});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final plotLeft = AppStatsTokens.chartHorizontalInset;
    final plotRight = size.width - AppStatsTokens.chartHorizontalInset;
    final plotTop = AppStatsTokens.chartTopInset;
    final plotBottom = size.height - AppStatsTokens.chartBottomInset;

    final maxCount = points.fold<int>(
      0,
      (max, point) => point.chaptersCount > max ? point.chaptersCount : max,
    );
    // Avoid dividing by zero on all-zero series.
    final maxValue = maxCount > 0 ? maxCount : 1;
    final axisStyle = textTheme.labelSmall?.copyWith(
      color: AppColors.secondaryText,
    );

    _drawAxisLabel(canvas, '0', Offset(plotLeft, plotBottom), axisStyle);
    _drawAxisLabel(canvas, '$maxValue', Offset(plotLeft, plotTop), axisStyle);

    // Baseline of the plot area.
    final axisPaint = Paint()
      ..color = AppColors.secondaryText
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(plotLeft, plotBottom),
      Offset(plotRight, plotBottom),
      axisPaint,
    );

    if (points.length == 1) {
      _drawNode(
        canvas,
        Offset((plotLeft + plotRight) / 2, plotBottom),
        points.first.chaptersCount > 0,
      );
      _drawXLabel(
        canvas,
        points.first.date,
        (plotLeft + plotRight) / 2,
        plotBottom,
        axisStyle,
      );
      return;
    }

    final positions = [
      for (var index = 0; index < points.length; index++)
        Offset(
          plotLeft + index * (plotRight - plotLeft) / (points.length - 1),
          plotBottom -
              points[index].chaptersCount / maxValue * (plotBottom - plotTop),
        ),
    ];

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppStatsTokens.chartLineWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.goldAccent;
    for (var index = 0; index < positions.length - 1; index++) {
      canvas.drawLine(positions[index], positions[index + 1], linePaint);
    }

    for (var index = 0; index < positions.length; index++) {
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

  @override
  bool shouldRepaint(_ChaptersLinePainter oldDelegate) =>
      oldDelegate.points != points;
}
