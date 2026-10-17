import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/utils/local_date_key.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Builds the last [dayCount] local days (today included), oldest first,
/// always filling each day even when no reading was recorded.
class GetRecentReadingDays {
  final ReadingRepository _repository;

  static const int defaultDayCount = 5;

  const GetRecentReadingDays(this._repository);

  Future<Either<Failure, List<ReadingDayEntity>>> call({
    DateTime? today,
    int dayCount = defaultDayCount,
  }) async {
    final now = today ?? DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final dates = [
      for (var offset = dayCount - 1; offset >= 0; offset--)
        localDateKey(nowDate.subtract(Duration(days: offset))),
    ];

    final totalsResult = await _repository.getReadingDayTotals(dates);
    return totalsResult.map((totals) {
      final byDate = {for (final total in totals) total.date: total};
      return [
        for (final date in dates)
          byDate[date] ??
              ReadingDayEntity(date: date, chaptersCount: 0, versesCount: 0),
      ].toList(growable: false);
    });
  }
}
