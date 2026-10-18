import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_splash_tokens.dart';

/// The app logo image, shared by the splash and the home screen.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = AppSplashTokens.logoSize});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo-splash.png',
      width: size,
      height: size,
    );
  }
}
