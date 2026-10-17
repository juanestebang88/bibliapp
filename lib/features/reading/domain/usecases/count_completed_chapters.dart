import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Counts the fully completed chapters of [book].
class CountCompletedChapters {
  final ReadingRepository _repository;

  const CountCompletedChapters(this._repository);

  Future<Either<Failure, int>> call(String book) =>
      _repository.countCompletedChapters(book);
}
