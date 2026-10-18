import 'package:get_it/get_it.dart';
import 'package:bibliapp/core/bootstrap/bible_bootstrap.dart';
import 'package:bibliapp/features/reading/data/bible_db_initialization.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/data/repositories/connectivity_repository_impl.dart';
import 'package:bibliapp/features/reading/data/repositories/reading_repository_impl.dart';
import 'package:bibliapp/features/reading/domain/repositories/connectivity_repository.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:bibliapp/features/reading/domain/usecases/add_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/check_internet_connectivity.dart';
import 'package:bibliapp/features/reading/domain/usecases/clear_reading_data.dart';
import 'package:bibliapp/features/reading/domain/usecases/count_completed_chapters.dart';
import 'package:bibliapp/features/reading/domain/usecases/delete_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/ensure_bible_imported.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_highlights.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_continue_reading.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_daily_verse.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_recent_reading_days.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_verse.dart';
import 'package:bibliapp/features/reading/domain/usecases/record_daily_reading_event.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_chapter_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/search_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/update_verse_highlight.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/search_cubit.dart';

/// Registers the reading feature: local database, repositories, use cases
/// and cubits. Other features resolve reading use cases from here.
void registerReadingModule(GetIt getIt) {
  if (getIt.isRegistered<ReadingDatabase>()) return;

  getIt.registerLazySingleton<ReadingDatabase>(
    () => ReadingDatabase(executor: openBibleDatabase()),
  );
  getIt.registerLazySingleton<ReadingLocalDataSource>(
    () => ReadingLocalDataSource(database: getIt<ReadingDatabase>()),
  );
  getIt.registerLazySingleton<ReadingRepository>(
    () => ReadingRepositoryImpl(dataSource: getIt<ReadingLocalDataSource>()),
  );
  getIt.registerLazySingleton<ConnectivityRepository>(
    ConnectivityRepositoryImpl.new,
  );
  getIt.registerFactory(() => GetVerse(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetChapterVerses(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetChapterCount(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetChapterProgress(getIt<ReadingRepository>()));
  getIt.registerFactory(() => SaveChapterProgress(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetReadingProgress(getIt<ReadingRepository>()));
  getIt.registerFactory(() => SaveReadingProgress(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetReadingSettings(getIt<ReadingRepository>()));
  getIt.registerFactory(() => SaveReadingSettings(getIt<ReadingRepository>()));
  getIt.registerFactory(() => ClearReadingData(getIt<ReadingRepository>()));
  getIt.registerFactory<BibleBootstrap>(
    () => EnsureBibleImported(getIt<ReadingRepository>()),
  );
  getIt.registerFactory(() => SearchVerses(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetChapterHighlights(getIt<ReadingRepository>()));
  getIt.registerFactory(() => AddVerseHighlight(getIt<ReadingRepository>()));
  getIt.registerFactory(() => UpdateVerseHighlight(getIt<ReadingRepository>()));
  getIt.registerFactory(() => DeleteVerseHighlight(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetContinueReading(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetDailyVerse(getIt<ReadingRepository>()));
  getIt.registerFactory(() => GetRecentReadingDays(getIt<ReadingRepository>()));
  getIt.registerFactory(
    () => CountCompletedChapters(getIt<ReadingRepository>()),
  );
  getIt.registerFactory(
    () => RecordDailyReadingEvent(getIt<ReadingRepository>()),
  );
  getIt.registerFactory(
    () => CheckInternetConnectivity(getIt<ConnectivityRepository>()),
  );
  getIt.registerFactory(() => SearchCubit(searchVerses: getIt<SearchVerses>()));
  getIt.registerFactory(
    () => ReadingCubit(
      getChapterVerses: getIt<GetChapterVerses>(),
      getChapterCount: getIt<GetChapterCount>(),
      getReadingProgress: getIt<GetReadingProgress>(),
      saveReadingProgress: getIt<SaveReadingProgress>(),
      getReadingSettings: getIt<GetReadingSettings>(),
      saveReadingSettings: getIt<SaveReadingSettings>(),
      getChapterProgress: getIt<GetChapterProgress>(),
      saveChapterProgress: getIt<SaveChapterProgress>(),
      getChapterHighlights: getIt<GetChapterHighlights>(),
      addVerseHighlight: getIt<AddVerseHighlight>(),
      updateVerseHighlight: getIt<UpdateVerseHighlight>(),
      deleteVerseHighlight: getIt<DeleteVerseHighlight>(),
      recordDailyReadingEvent: getIt<RecordDailyReadingEvent>(),
    ),
  );
  getIt.registerFactory(
    () => PassagePickerCubit(
      getChapterCount: getIt<GetChapterCount>(),
      getChapterVerses: getIt<GetChapterVerses>(),
    ),
  );
}
