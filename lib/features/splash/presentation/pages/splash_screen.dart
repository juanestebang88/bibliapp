import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_state.dart';
import 'package:bibliapp/features/splash/presentation/widgets/splash_error_view.dart';
import 'package:bibliapp/features/splash/presentation/widgets/splash_loading_view.dart';

/// App bootstrap screen: shows the breathing logo while the Bible text is
/// imported and navigates to the home screen once ready.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == SplashStatus.ready) {
            context.go('/home');
          }
        },
        child: BlocBuilder<SplashCubit, SplashState>(
          builder: (context, state) {
            if (state.status == SplashStatus.failure) {
              return SplashErrorView(
                message: state.errorMessage,
                onRetry: () => context.read<SplashCubit>().retry(),
              );
            }
            return const Center(child: SplashLoadingView());
          },
        ),
      ),
    );
  }
}
