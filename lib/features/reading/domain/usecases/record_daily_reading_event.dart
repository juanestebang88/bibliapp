import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Records a reading event for the day, keeping the max verse count per
/// (date, book, chapter); repeated marks are never summed.
class RecordDailyReadingEvent {
  final ReadingRepository _repository;

  const RecordDailyReadingEvent(this._repository);

  Future<Either<Failure, bool>> call(
    String activityDate,
    String book,
    int chapter,
    int verseCount,
  ) => _repository.markReadingEvent(activityDate, book, chapter, verseCount);
}
