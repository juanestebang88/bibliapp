import 'package:get_it/get_it.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_books_reading_stats.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapters_series.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_overview.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';

/// Registers the stats feature. Presentation only: data and use cases live
/// in the reading module, following the home screen pattern (spec 19).
void registerStatsModule(GetIt getIt) {
  if (getIt.isRegistered<StatsCubit>()) return;
  getIt.registerFactory(
    () => StatsCubit(
      getReadingOverview: getIt<GetReadingOverview>(),
      getChaptersSeries: getIt<GetChaptersSeries>(),
      getBooksReadingStats: getIt<GetBooksReadingStats>(),
    ),
  );
}
