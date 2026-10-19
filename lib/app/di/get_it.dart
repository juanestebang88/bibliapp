import 'package:get_it/get_it.dart';
import 'package:bibliapp/features/home/di/home_module.dart';
import 'package:bibliapp/features/reading/di/reading_module.dart';
import 'package:bibliapp/features/stats/di/stats_module.dart';
import 'package:bibliapp/features/splash/di/splash_module.dart';

final GetIt getIt = GetIt.instance;

/// Composition root: invokes every feature module exactly once.
void registerGetIt() {
  registerReadingModule(getIt);
  registerHomeModule(getIt);
  registerStatsModule(getIt);
  registerSplashModule(getIt);
}
