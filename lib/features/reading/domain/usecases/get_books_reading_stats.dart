import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/book_order.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Per-book reading summaries for the whole canon (all 66 books), in the
/// canonical order. Books without marks come back with zeroed counters.
class GetBooksReadingStats {
  final ReadingRepository _repository;

  const GetBooksReadingStats(this._repository);

  Future<Either<Failure, List<BookReadingStatsEntity>>> call() async {
    final summariesResult = await _repository.getBookReadingSummaries();
    return summariesResult.map((summaries) {
      final byBook = {for (final summary in summaries) summary.book: summary};
      return [
        for (final book in bibleBookOrder)
          byBook[book] ??
              BookReadingStatsEntity(
                book: book,
                completedChapters: 0,
                totalChapters: 0,
              ),
      ].toList(growable: false);
    });
  }
}
