import 'package:get_it/get_it.dart';
import 'package:bibliapp/core/bootstrap/bible_bootstrap.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_cubit.dart';

/// Registers the splash cubit, wired to the bootstrap port implemented by the
/// reading feature.
void registerSplashModule(GetIt getIt) {
  if (getIt.isRegistered<SplashCubit>()) return;

  getIt.registerFactory(
    () => SplashCubit(bibleBootstrap: getIt<BibleBootstrap>()),
  );
}
