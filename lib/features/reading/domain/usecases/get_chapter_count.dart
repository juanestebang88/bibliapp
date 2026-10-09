import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetChapterCount {
  final ReadingRepository _repository;

  const GetChapterCount(this._repository);

  Future<Either<Failure, int>> call(String book) =>
      _repository.getChapterCount(book);
}
