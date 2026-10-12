import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/core/theme/app_splash_tokens.dart';

/// Splash logo with a continuous breathing pulse (scale + fade) that signals
/// activity while the app bootstraps.
class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  /// Identifies the breathing wrapper (used by tests).
  static const Key breathScaleKey = Key('splash-breath-scale');

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.splashBreathDuration,
    )..repeat(reverse: true);
    final breathing = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.chromeCurve,
    );
    _scale = Tween<double>(
      begin: 1,
      end: AppSplashTokens.breathScale,
    ).animate(breathing);
    _opacity = Tween<double>(
      begin: 1,
      end: AppSplashTokens.breathOpacity,
    ).animate(breathing);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        key: SplashLogo.breathScaleKey,
        scale: _scale,
        child: Image.asset(
          'assets/images/logo-splash.png',
          width: AppSplashTokens.logoSize,
          height: AppSplashTokens.logoSize,
        ),
      ),
    );
  }
}
