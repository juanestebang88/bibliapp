import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_splash_tokens.dart';
import 'package:bibliapp/features/splash/presentation/widgets/splash_logo.dart';

/// Splash loading state: the breathing logo with a loading bar underneath.
class SplashLoadingView extends StatelessWidget {
  const SplashLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SplashLogo(),
        const SizedBox(height: AppSpacing.xxl),
        SizedBox(
          width: AppSplashTokens.progressWidth,
          child: LinearProgressIndicator(
            minHeight: AppSplashTokens.progressThickness,
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ],
    );
  }
}
