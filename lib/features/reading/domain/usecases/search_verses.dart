import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/utils/search_text.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchVerses {
  final ReadingRepository _repository;

  const SearchVerses(this._repository);

  Future<Either<Failure, List<VerseEntity>>> call(String rawQuery) async {
    final words = searchQueryWords(rawQuery);
    if (words.isEmpty) return const Right<Failure, List<VerseEntity>>([]);
    return _repository.searchVerses(words);
  }
}
