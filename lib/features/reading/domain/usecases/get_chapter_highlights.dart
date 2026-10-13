import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChapterHighlights {
  final ReadingRepository _repository;

  const GetChapterHighlights(this._repository);

  Future<Either<Failure, List<VerseHighlightEntity>>> call(
    String book,
    int chapter,
  ) => _repository.getChapterHighlights(book, chapter);
}
