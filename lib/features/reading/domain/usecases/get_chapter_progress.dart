import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChapterProgress {
  final ReadingRepository _repository;

  const GetChapterProgress(this._repository);

  Future<Either<Failure, ChapterProgressEntity?>> call(
    String book,
    int chapter,
  ) => _repository.getChapterProgress(book, chapter);
}
