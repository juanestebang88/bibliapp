import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/data/repositories/reading_repository_impl.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';

void main() {
  late ReadingDatabase database;
  late ReadingLocalDataSource dataSource;

  setUp(() {
    database = ReadingDatabase(executor: NativeDatabase.memory());
    dataSource = ReadingLocalDataSource(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  test('stores verses idempotently and returns them in verse order', () async {
    const verses = [
      VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'Second'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'First'),
    ];

    await dataSource.importRV1960(verses);
    await dataSource.importRV1960(verses);

    expect(await dataSource.hasImportedVerses(), isTrue);
    expect(await dataSource.getChapterVerses('genesis', 1), const [
      VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'First'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'Second'),
    ]);
  });

  test('stores one typed reading progress and clears local data', () async {
    const progress = ReadingProgressEntity(lastBook: 'john', lastChapter: 3);

    await dataSource.saveReadingProgress(progress);

    expect(await dataSource.getReadingProgress(), progress);
    await dataSource.clearAllData();
    expect(await dataSource.getReadingProgress(), isNull);
    expect(await dataSource.hasImportedVerses(), isFalse);
  });

  test('persists and clears the font size setting', () async {
    expect(await dataSource.getFontSize(), isNull);

    await dataSource.saveFontSize(24);

    expect(await dataSource.getFontSize(), 24);
    await dataSource.clearAllData();
    expect(await dataSource.getFontSize(), isNull);
  });

  test('returns the highest chapter stored for a book', () async {
    await dataSource.importRV1960(const [
      VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'First'),
      VerseEntity(book: 'genesis', chapter: 50, verse: 1, text: 'Last'),
      VerseEntity(book: 'exodus', chapter: 1, verse: 1, text: 'Next book'),
    ]);

    expect(await dataSource.getMaxChapter('genesis'), 50);
    expect(await dataSource.getMaxChapter('exodus'), 1);
  });

  test('maps local database errors to a typed failure', () async {
    final failingDataSource = _FailingReadingLocalDataSource();
    final repository = ReadingRepositoryImpl(dataSource: failingDataSource);
    when(() => failingDataSource.getVerse('genesis', 1, 1))
        .thenThrow(StateError('database unavailable'));

    final result = await repository.getVerse('genesis', 1, 1);

    expect(
      result.match((failure) => failure.message, (_) => ''),
      contains('database unavailable'),
    );
  });

  test('upserts chapter progress per chapter and returns it', () async {
    const partial = ChapterProgressEntity(
      book: 'genesis',
      chapter: 1,
      lastVerseRead: 7,
      isComplete: false,
    );

    await dataSource.saveChapterProgress(partial);

    expect(await dataSource.getChapterProgress('genesis', 1), partial);
    expect(await dataSource.getChapterProgress('genesis', 2), isNull);

    final complete = ChapterProgressEntity(
      book: 'genesis',
      chapter: 1,
      lastVerseRead: 3,
      isComplete: true,
      completedAt: DateTime.fromMillisecondsSinceEpoch(1700000000000),
    );

    await dataSource.saveChapterProgress(complete);

    expect(await dataSource.getChapterProgress('genesis', 1), complete);
  });

  test('unmarking resets the chapter progress values', () async {
    const complete = ChapterProgressEntity(
      book: 'genesis',
      chapter: 2,
      lastVerseRead: 3,
      isComplete: true,
      completedAt: null,
    );
    await dataSource.saveChapterProgress(complete);

    const unmarked = ChapterProgressEntity(
      book: 'genesis',
      chapter: 2,
      lastVerseRead: 0,
      isComplete: false,
    );
    await dataSource.saveChapterProgress(unmarked);

    expect(await dataSource.getChapterProgress('genesis', 2), unmarked);
  });

  test('clearAllData removes the saved chapter progress', () async {
    await dataSource.saveChapterProgress(
      const ChapterProgressEntity(
        book: 'genesis',
        chapter: 1,
        lastVerseRead: 2,
        isComplete: false,
      ),
    );

    await dataSource.clearAllData();

    expect(await dataSource.getChapterProgress('genesis', 1), isNull);
  });

  test('stores a verse highlight and returns it with a generated id', () async {
    final highlight = _highlight(
      startOffset: 2,
      endOffset: 7,
      color: HighlightColor.green,
    );

    final saved = await dataSource.addVerseHighlight(highlight);

    expect(saved.id, isNotNull);
    expect(saved.startOffset, 2);
    expect(saved.endOffset, 7);
    expect(saved.color, HighlightColor.green);

    final stored = await dataSource.getChapterHighlights('genesis', 1);
    expect(stored, [saved]);
  });

  test('getChapterHighlights only returns the requested chapter', () async {
    await dataSource.addVerseHighlight(_highlight(verse: 1));
    await dataSource.addVerseHighlight(_highlight(verse: 2));
    await dataSource.addVerseHighlight(
      _highlight(book: 'exodus', chapter: 1, verse: 1),
    );

    final genesis = await dataSource.getChapterHighlights('genesis', 1);

    expect(genesis, hasLength(2));
    expect(genesis.every((highlight) => highlight.book == 'genesis'), isTrue);
  });

  test('updates the color and timestamps of a highlight', () async {
    final saved = await dataSource.addVerseHighlight(
      _highlight(color: HighlightColor.yellow),
    );

    final updated = saved.copyWith(
      color: HighlightColor.blue,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(5000),
    );
    await dataSource.updateVerseHighlight(updated);

    final stored = await dataSource.getChapterHighlights('genesis', 1);
    expect(stored, [updated]);
  });

  test('deletes a highlight by id', () async {
    final saved = await dataSource.addVerseHighlight(_highlight());
    await dataSource.addVerseHighlight(_highlight(verse: 2));

    await dataSource.deleteVerseHighlight(saved.id!);

    final stored = await dataSource.getChapterHighlights('genesis', 1);
    expect(stored, hasLength(1));
    expect(stored.single.verse, 2);
  });

  test('clearAllData removes every stored highlight', () async {
    await dataSource.addVerseHighlight(_highlight());

    await dataSource.clearAllData();

    expect(await dataSource.getChapterHighlights('genesis', 1), isEmpty);
  });
}

VerseHighlightEntity _highlight({
  String book = 'genesis',
  int chapter = 1,
  int verse = 1,
  int startOffset = 0,
  int endOffset = 3,
  HighlightColor color = HighlightColor.yellow,
}) => VerseHighlightEntity(
  book: book,
  chapter: chapter,
  verse: verse,
  startOffset: startOffset,
  endOffset: endOffset,
  color: color,
  createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(1000),
);

class _FailingReadingLocalDataSource extends Mock
    implements ReadingLocalDataSource {}
