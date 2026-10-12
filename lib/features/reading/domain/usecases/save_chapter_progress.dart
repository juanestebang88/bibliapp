import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveChapterProgress {
  final ReadingRepository _repository;

  const SaveChapterProgress(this._repository);

  Future<Either<Failure, bool>> call(ChapterProgressEntity progress) =>
      _repository.saveChapterProgress(progress);
}
