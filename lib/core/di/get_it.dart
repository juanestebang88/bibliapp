import 'package:get_it/get_it.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/data/repositories/reading_repository_impl.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:bibliapp/features/reading/domain/usecases/clear_reading_data.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_verse.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

final GetIt getIt = GetIt.instance;

void registerGetIt() {
  if (getIt.isRegistered<ReadingDatabase>()) return;

  getIt.registerLazySingleton<ReadingDatabase>(ReadingDatabase.new);
  getIt.registerLazySingleton<ReadingLocalDataSource>(
    () => ReadingLocalDataSource(database: getIt<ReadingDatabase>()),
  );
  getIt.registerLazySingleton<ReadingRepository>(
    () => ReadingRepositoryImpl(dataSource: getIt<ReadingLocalDataSource>()),
  );
  getIt.registerFactory(() => GetVerse(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetChapterVerses(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetChapterCount(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetReadingProgress(getIt<ReadingRepository>()));
  getIt.registerFactory(() => SaveReadingProgress(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetReadingSettings(getIt<ReadingRepository>()));
  getIt.registerFactory(() => SaveReadingSettings(getIt<ReadingRepository>()));
  getIt.registerFactory(() => ClearReadingData(getIt<ReadingRepository>()));
  getIt.registerFactory(
    () => ReadingCubit(
      getChapterVerses: getIt<GetChapterVerses>(),
      getChapterCount: getIt<GetChapterCount>(),
      getReadingProgress: getIt<GetReadingProgress>(),
      saveReadingProgress: getIt<SaveReadingProgress>(),
      getReadingSettings: getIt<GetReadingSettings>(),
      saveReadingSettings: getIt<SaveReadingSettings>(),
    ),
  );
}
