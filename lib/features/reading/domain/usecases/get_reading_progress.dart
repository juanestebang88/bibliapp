import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetReadingProgress {
  final ReadingRepository _repository;

  const GetReadingProgress(this._repository);

  Future<Either<Failure, ReadingProgressEntity?>> call() =>
      _repository.getReadingProgress();
}
