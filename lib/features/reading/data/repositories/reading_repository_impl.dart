import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class ReadingRepositoryImpl implements ReadingRepository {
  final ReadingLocalDataSource dataSource;

  ReadingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, VerseEntity?>> getVerse(
    String book,
    int chapter,
    int verse,
  ) => _guard(() => dataSource.getVerse(book, chapter, verse));

  @override
  Future<Either<Failure, List<VerseEntity>>> getChapterVerses(
    String book,
    int chapter,
  ) => _guard(() => dataSource.getChapterVerses(book, chapter));

  @override
  Future<Either<Failure, int>> getChapterCount(String book) =>
      _guard(() => dataSource.getMaxChapter(book));

  @override
  Future<Either<Failure, bool>> saveReadingProgress(
    ReadingProgressEntity progress,
  ) => _guard(() async {
    await dataSource.saveReadingProgress(progress);
    return true;
  });

  @override
  Future<Either<Failure, ReadingProgressEntity?>> getReadingProgress() =>
      _guard(dataSource.getReadingProgress);

  @override
  Future<Either<Failure, ReadingSettingsEntity?>> getReadingSettings() async {
    try {
      final fontSize = await dataSource.getFontSize();
      return Right(
        fontSize == null ? null : ReadingSettingsEntity(fontSize: fontSize),
      );
    } on Object catch (error) {
      return Left(DatabaseFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveReadingSettings(
    ReadingSettingsEntity settings,
  ) => _guard(() async {
    await dataSource.saveFontSize(settings.fontSize);
    return true;
  });

  @override
  Future<Either<Failure, bool>> clearAllData() => _guard(() async {
    await dataSource.clearAllData();
    return true;
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() operation) async {
    try {
      return Right(await operation());
    } on Object catch (error) {
      return Left(DatabaseFailure(error.toString()));
    }
  }
}
