import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateVerseHighlight {
  final ReadingRepository _repository;

  const UpdateVerseHighlight(this._repository);

  Future<Either<Failure, bool>> call(VerseHighlightEntity highlight) =>
      _repository.updateVerseHighlight(highlight);
}
