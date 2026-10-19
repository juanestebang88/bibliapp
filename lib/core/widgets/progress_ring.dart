import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_colors.dart';

/// Circular progress ring drawn with CustomPaint. Reused by the big overall
/// donut and the mini per-book ring (spec 19). No animations, no state.
class ProgressRing extends StatelessWidget {
  /// Completion ratio from 0.0 (empty) to 1.0 (full circle).
  final double progress;
  final double size;
  final double strokeWidth;

  /// Optional widget (usually the percent text) drawn at the ring center.
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.size,
    required this.strokeWidth,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress.clamp(0.0, 1.0),
          strokeWidth: strokeWidth,
        ),
        child: child == null ? null : Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  _RingPainter({required this.progress, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final arcRect = Rect.fromLTRB(
      inset,
      inset,
      size.width - inset,
      size.height - inset,
    );

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = AppColors.pillBackground;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, trackPaint);

    if (progress <= 0) return;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.goldAccent;
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.strokeWidth != strokeWidth;
}
