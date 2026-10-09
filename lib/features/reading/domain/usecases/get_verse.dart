import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetVerse {
  final ReadingRepository _repository;

  const GetVerse(this._repository);

  Future<Either<Failure, VerseEntity?>> call(
    String book,
    int chapter,
    int verse,
  ) => _repository.getVerse(book, chapter, verse);
}
