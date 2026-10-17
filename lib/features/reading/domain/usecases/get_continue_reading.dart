import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/continue_reading_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Resolves where the user should continue reading based on the latest
/// reading mark (partial wins if it is the most recent, otherwise the
/// chapter after the last completed one). Null when nothing is marked yet.
class GetContinueReading {
  final ReadingRepository _repository;

  const GetContinueReading(this._repository);

  Future<Either<Failure, ContinueReadingEntity?>> call() =>
      _repository.getContinueReading();
}
