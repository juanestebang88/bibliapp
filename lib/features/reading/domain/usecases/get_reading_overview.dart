import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/utils/local_date_key.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Aggregated reading numbers for a list of books (a stats tab scope):
/// completed chapters, yesterday vs today, duration since the first mark
/// and the rolling week-over-week change (spec 19).
class GetReadingOverview {
  final ReadingRepository _repository;

  const GetReadingOverview(this._repository);

  Future<Either<Failure, ReadingOverviewEntity>> call(
    List<String> books, {
    DateTime? today,
  }) async {
    final now = today ?? DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    // Last 14 local days (today included) cover both rolling weeks.
    final dates = [
      for (var offset = 13; offset >= 0; offset--)
        localDateKey(nowDate.subtract(Duration(days: offset))),
    ];

    final summariesResult = await _repository.getBookReadingSummaries();
    final countsResult = await _repository.getDailyChaptersCounts(
      dates: dates,
      books: books,
    );
    return countsResult.flatMap(
      (counts) => summariesResult.map(
        (summaries) => _buildOverview(summaries, counts, books, nowDate),
      ),
    );
  }

  ReadingOverviewEntity _buildOverview(
    List<BookReadingStatsEntity> summaries,
    List<ChaptersSeriesPointEntity> counts,
    List<String> books,
    DateTime nowDate,
  ) {
    final scope = books.toSet();
    final scopedSummaries = [
      for (final summary in summaries)
        if (scope.contains(summary.book)) summary,
    ];
    final countsByDate = {for (final count in counts) count.date: count};

    var completedChapters = 0;
    var totalChapters = 0;
    DateTime? firstMarkAt;
    for (final summary in scopedSummaries) {
      completedChapters += summary.completedChapters;
      totalChapters += summary.totalChapters;
      final mark = summary.firstMarkAt;
      if (mark != null && (firstMarkAt == null || mark.isBefore(firstMarkAt))) {
        firstMarkAt = mark;
      }
    }

    int chaptersOn(DateTime day) =>
        countsByDate[localDateKey(day)]?.chaptersCount ?? 0;

    var currentWeekChapters = 0;
    var previousWeekChapters = 0;
    for (var offset = 0; offset < 7; offset++) {
      currentWeekChapters += chaptersOn(
        nowDate.subtract(Duration(days: offset)),
      );
      previousWeekChapters += chaptersOn(
        nowDate.subtract(Duration(days: offset + 7)),
      );
    }

    var daysSinceFirstMark = 0;
    if (firstMarkAt != null) {
      final firstMarkDate = DateTime(
        firstMarkAt.year,
        firstMarkAt.month,
        firstMarkAt.day,
      );
      final days = nowDate.difference(firstMarkDate).inDays;
      daysSinceFirstMark = days > 0 ? days : 0;
    }

    return ReadingOverviewEntity(
      completedChapters: completedChapters,
      totalChapters: totalChapters,
      chaptersYesterday: chaptersOn(nowDate.subtract(const Duration(days: 1))),
      chaptersToday: chaptersOn(nowDate),
      daysSinceFirstMark: daysSinceFirstMark,
      currentWeekChapters: currentWeekChapters,
      previousWeekChapters: previousWeekChapters,
    );
  }
}
