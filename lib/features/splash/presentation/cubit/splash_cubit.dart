import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/features/reading/domain/usecases/ensure_bible_imported.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_state.dart';

/// Orchestrates the app bootstrap: ensures the Bible text is available and
/// keeps the splash on screen for a minimum time before reporting ready.
class SplashCubit extends Cubit<SplashState> {
  final EnsureBibleImported ensureBibleImported;

  SplashCubit({required this.ensureBibleImported}) : super(const SplashState());

  Future<void> initialize() async {
    emit(const SplashState(status: SplashStatus.loading));

    final minimumElapsed = Future<void>.delayed(AppMotion.splashMinDuration);
    final result = await ensureBibleImported.ensureImported();
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
