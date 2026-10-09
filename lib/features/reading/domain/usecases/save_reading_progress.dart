import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveReadingProgress {
  final ReadingRepository _repository;

  const SaveReadingProgress(this._repository);

  Future<Either<Failure, bool>> call(ReadingProgressEntity progress) =>
      _repository.saveReadingProgress(progress);
}
