import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/bootstrap/bible_bootstrap.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_state.dart';

/// Orchestrates the app bootstrap: ensures the Bible text is imported and
/// keeps the splash on screen for a minimum time before reporting ready.
class SplashCubit extends Cubit<SplashState> {
  final BibleBootstrap bibleBootstrap;

  SplashCubit({required this.bibleBootstrap}) : super(const SplashState());

  Future<void> initialize() async {
    emit(const SplashState(status: SplashStatus.loading));

    final minimumElapsed = Future<void>.delayed(AppMotion.splashMinDuration);
    final result = await bibleBootstrap.ensureImported();
    await minimumElapsed;

    result.match(
      (failure) => emit(
        SplashState(
          status: SplashStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const SplashState(status: SplashStatus.ready)),
    );
  }

  Future<void> retry() => initialize();
}
