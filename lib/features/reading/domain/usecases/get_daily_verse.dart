import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/utils/local_date_key.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Returns the daily verse for today: the one already saved for the day, or a
/// freshly picked random verse persisted as the single daily row.
class GetDailyVerse {
  final ReadingRepository _repository;

  const GetDailyVerse(this._repository);

  Future<Either<Failure, DailyVerseEntity>> call({DateTime? today}) async {
    final day = localDateKey(today ?? DateTime.now());

    final savedResult = await _repository.getSavedDailyVerse(day);
    final saved = savedResult.getOrElse((_) => null);
    if (saved != null) {
      final textResult = await _repository.getVerse(
        saved.book,
        saved.chapter,
        saved.verse,
      );
      return textResult.map(
        (text) => DailyVerseEntity(
          book: saved.book,
          chapter: saved.chapter,
          verse: saved.verse,
          text: text?.text ?? '',
        ),
      );
    }

    final randomResult = await _repository.getRandomVerse();
    return randomResult.match(Left.new, (random) async {
      final saveResult = await _repository.saveDailyVerse(random, day);
      return saveResult.match(
        Left.new,
        (_) => Right<Failure, DailyVerseEntity>(random),
      );
    });
  }
}
