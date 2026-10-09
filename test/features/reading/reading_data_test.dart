import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/data/repositories/reading_repository_impl.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';

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
    const progress = ReadingProgressEntity(
      lastBook: 'john',
      lastChapter: 3,
      lastVerse: 16,
      timestamp: 123,
    );

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
}

class _FailingReadingLocalDataSource extends Mock
    implements ReadingLocalDataSource {}
