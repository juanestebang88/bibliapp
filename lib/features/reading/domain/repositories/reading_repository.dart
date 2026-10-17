import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:fpdart/fpdart.dart';

/// Contract for accessing Bible text and reading progress.
abstract class ReadingRepository {
  Future<Either<Failure, VerseEntity?>> getVerse(
    String book,
    int chapter,
    int verse,
  );

  Future<Either<Failure, List<VerseEntity>>> getChapterVerses(
    String book,
    int chapter,
  );

  Future<Either<Failure, int>> getChapterCount(String book);

  Future<Either<Failure, bool>> saveReadingProgress(
    ReadingProgressEntity progress,
  );

  Future<Either<Failure, ReadingProgressEntity?>> getReadingProgress();

  Future<Either<Failure, ReadingSettingsEntity?>> getReadingSettings();

  Future<Either<Failure, bool>> saveReadingSettings(
    ReadingSettingsEntity settings,
  );

  Future<Either<Failure, ChapterProgressEntity?>> getChapterProgress(
    String book,
    int chapter,
  );

  Future<Either<Failure, bool>> saveChapterProgress(
    ChapterProgressEntity progress,
  );

  Future<Either<Failure, bool>> clearAllData();

  Future<Either<Failure, List<VerseEntity>>> searchVerses(List<String> words);

  Future<Either<Failure, List<VerseHighlightEntity>>> getChapterHighlights(
    String book,
    int chapter,
  );

  Future<Either<Failure, VerseHighlightEntity>> addVerseHighlight(
    VerseHighlightEntity highlight,
  );

  Future<Either<Failure, bool>> updateVerseHighlight(
    VerseHighlightEntity highlight,
  );

  Future<Either<Failure, bool>> deleteVerseHighlight(int id);

  /// Imports the Bible text into the local database if it is not there yet.
  Future<Either<Failure, Unit>> ensureBibleImported();

  /// Saved daily verse row for [day], or null when nothing is saved yet.
  /// The returned entity has empty text: fetch it with [getVerse].
  Future<Either<Failure, DailyVerseEntity?>> getSavedDailyVerse(String day);

  /// Picks a random real verse from the canon (with its text).
  Future<Either<Failure, DailyVerseEntity>> getRandomVerse();

  /// Persists the daily verse as the single row for [day].
  Future<Either<Failure, bool>> saveDailyVerse(
    DailyVerseEntity dailyVerse,
    String day,
  );

  /// Records a reading event for [activityDate], keeping the max verse count
  /// per (date, book, chapter).
  Future<Either<Failure, bool>> markReadingEvent(
    String activityDate,
    String book,
    int chapter,
    int verseCount,
  );

  /// Number of fully completed chapters of [book].
  Future<Either<Failure, int>> countCompletedChapters(String book);

  /// Reading totals for each requested local date.
  Future<Either<Failure, List<ReadingDayEntity>>> getReadingDayTotals(
    List<String> dates,
  );
}
