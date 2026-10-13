import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:bibliapp/features/reading/domain/usecases/add_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/delete_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_highlights.dart';
import 'package:bibliapp/features/reading/domain/usecases/update_verse_highlight.dart';

class _MockReadingRepository extends Mock implements ReadingRepository {}

void main() {
  late _MockReadingRepository repository;

  final highlight = VerseHighlightEntity(
    id: 3,
    book: 'genesis',
    chapter: 1,
    verse: 1,
    startOffset: 0,
    endOffset: 4,
    color: HighlightColor.blue,
    createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(1000),
  );

  setUp(() {
    repository = _MockReadingRepository();
  });

  setUpAll(() {
    registerFallbackValue(
      VerseHighlightEntity(
        book: 'genesis',
        chapter: 1,
        verse: 1,
        startOffset: 0,
        endOffset: 1,
        color: HighlightColor.yellow,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1000),
      ),
    );
  });

  test('GetChapterHighlights delegates to the repository', () async {
    when(() => repository.getChapterHighlights('genesis', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseHighlightEntity>>([highlight]),
    );

    final result = await GetChapterHighlights(repository)('genesis', 1);

    expect(result.getOrElse((_) => const []), [highlight]);
    verify(() => repository.getChapterHighlights('genesis', 1)).called(1);
  });

  test('AddVerseHighlight delegates to the repository', () async {
    when(
      () => repository.addVerseHighlight(any()),
    ).thenAnswer((_) async => Right<Failure, VerseHighlightEntity>(highlight));

    final result = await AddVerseHighlight(repository)(highlight);

    expect(result.getOrElse((_) => highlight), highlight);
    verify(() => repository.addVerseHighlight(highlight)).called(1);
  });

  test('UpdateVerseHighlight delegates to the repository', () async {
    when(() => repository.updateVerseHighlight(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));

    final result = await UpdateVerseHighlight(repository)(highlight);

    expect(result.getOrElse((_) => false), isTrue);
    verify(() => repository.updateVerseHighlight(highlight)).called(1);
  });

  test('DeleteVerseHighlight delegates to the repository', () async {
    when(() => repository.deleteVerseHighlight(7))
        .thenAnswer((_) async => const Right<Failure, bool>(true));

    final result = await DeleteVerseHighlight(repository)(7);

    expect(result.getOrElse((_) => false), isTrue);
    verify(() => repository.deleteVerseHighlight(7)).called(1);
  });
}
