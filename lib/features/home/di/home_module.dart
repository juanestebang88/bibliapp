import 'package:get_it/get_it.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_cubit.dart';
import 'package:bibliapp/features/reading/domain/usecases/count_completed_chapters.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_continue_reading.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_daily_verse.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_recent_reading_days.dart';

/// Registers the home cubit. Home is a consumer feature: it only depends on
/// reading domain use cases, registered by the reading module.
void registerHomeModule(GetIt getIt) {
  if (getIt.isRegistered<HomeCubit>()) return;

  getIt.registerFactory(
    () => HomeCubit(
      getDailyVerse: getIt<GetDailyVerse>(),
      getContinueReading: getIt<GetContinueReading>(),
      getChapterCount: getIt<GetChapterCount>(),
      countCompletedChapters: getIt<CountCompletedChapters>(),
      getRecentReadingDays: getIt<GetRecentReadingDays>(),
    ),
  );
}
