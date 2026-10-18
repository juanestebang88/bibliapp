import 'package:get_it/get_it.dart';
import 'package:bibliapp/features/reading/domain/usecases/ensure_bible_imported.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_cubit.dart';

/// Registers the splash cubit, wired to the Bible availability check provided
/// by the reading domain.
void registerSplashModule(GetIt getIt) {
  if (getIt.isRegistered<SplashCubit>()) return;

  getIt.registerFactory(
    () => SplashCubit(ensureBibleImported: getIt<EnsureBibleImported>()),
  );
}
