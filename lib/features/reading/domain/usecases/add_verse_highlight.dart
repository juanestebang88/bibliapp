import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddVerseHighlight {
  final ReadingRepository _repository;

  const AddVerseHighlight(this._repository);

  Future<Either<Failure, VerseHighlightEntity>> call(
    VerseHighlightEntity highlight,
  ) => _repository.addVerseHighlight(highlight);
}
