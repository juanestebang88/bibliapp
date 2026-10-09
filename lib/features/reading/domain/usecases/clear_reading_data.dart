import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class ClearReadingData {
  final ReadingRepository _repository;

  const ClearReadingData(this._repository);

  Future<Either<Failure, bool>> call() => _repository.clearAllData();
}
