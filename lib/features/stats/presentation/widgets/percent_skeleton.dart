import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';

/// Rounded placeholder shown at the donut center while a tab switch
/// recalculates the stats (spec 22). Sweeps a highlight across a static bar.
class PercentSkeleton extends StatefulWidget {
  const PercentSkeleton({super.key});

  @override
  State<PercentSkeleton> createState() => _PercentSkeletonState();
}

class _PercentSkeletonState extends State<PercentSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.skeletonShimmerDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.sm);
    if (MediaQuery.of(context).disableAnimations) {
      return _bar(radius: radius, sweep: null);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => _bar(radius: radius, sweep: _controller.value),
    );
  }

  Widget _bar({required BorderRadius radius, required double? sweep}) {
    final clear = AppColors.offWhite.withValues(alpha: 0);
    final highlight = AppColors.offWhite.withValues(
      alpha: AppStatsTokens.skeletonHighlightOpacity,
    );
    return SizedBox(
      width: AppStatsTokens.percentSkeletonWidth,
      height: AppStatsTokens.percentSkeletonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.pillBackground,
          borderRadius: radius,
        ),
        child: sweep == null
            ? null
            : ClipRRect(
                borderRadius: radius,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1.5 + 3 * sweep, 0),
                      end: Alignment(-0.5 + 3 * sweep, 0),
                      colors: [clear, highlight, clear],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
