import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
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

  Future<Either<Failure, bool>> clearAllData();

  Future<Either<Failure, List<VerseEntity>>> searchVerses(List<String> words);
}
