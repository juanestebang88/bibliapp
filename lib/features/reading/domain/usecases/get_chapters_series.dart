import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/utils/local_date_key.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// One node per day from [from] to [to] (both included), oldest first,
/// filling days without records with zero (spec 19).
class GetChaptersSeries {
  final ReadingRepository _repository;

  const GetChaptersSeries(this._repository);

  Future<Either<Failure, List<ChaptersSeriesPointEntity>>> call({
    required List<String> books,
    required DateTime from,
    required DateTime to,
  }) async {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    final totalDays = toDate.difference(fromDate).inDays;
    if (totalDays < 0 || books.isEmpty) return Right(const []);

    final dates = [
      for (var offset = 0; offset <= totalDays; offset++)
        localDateKey(fromDate.add(Duration(days: offset))),
    ];

    final countsResult = await _repository.getDailyChaptersCounts(
      dates: dates,
      books: books,
    );
    return countsResult.map((counts) {
      final byDate = {for (final count in counts) count.date: count};
      return [
        for (final date in dates)
          byDate[date] ??
              ChaptersSeriesPointEntity(date: date, chaptersCount: 0),
      ].toList(growable: false);
    });
  }
}
