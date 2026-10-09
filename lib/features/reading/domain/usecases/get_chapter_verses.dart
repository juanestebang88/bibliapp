import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChapterVerses {
  final ReadingRepository _repository;

  const GetChapterVerses(this._repository);

  Future<Either<Failure, List<VerseEntity>>> call(String book, int chapter) =>
      _repository.getChapterVerses(book, chapter);
}
