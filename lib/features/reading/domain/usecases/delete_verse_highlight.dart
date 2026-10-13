import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteVerseHighlight {
  final ReadingRepository _repository;

  const DeleteVerseHighlight(this._repository);

  Future<Either<Failure, bool>> call(int id) =>
      _repository.deleteVerseHighlight(id);
}
