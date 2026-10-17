import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
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

  const verses = [
    VerseEntity(
      book: 'genesis',
      chapter: 1,
      verse: 1,
      text: 'En el principio creó Dios los cielos',
      isVerseNumber: true,
    ),
    VerseEntity(
      book: 'genesis',
      chapter: 1,
      verse: 2,
      text: 'Y la tierra estaba desordenada y vacía',
    ),
    VerseEntity(book: 'john', chapter: 3, verse: 16, text: 'De tal manera amó'),
  ];

  group('markReadingEvent', () {
    test('keeps the max verse count and never duplicates rows', () async {
      await dataSource.importRV1960(verses);

      await dataSource.markReadingEvent('2026-10-17', 'genesis', 1, 10);
      await dataSource.markReadingEvent('2026-10-17', 'genesis', 1, 20);
      await dataSource.markReadingEvent('2026-10-17', 'genesis', 1, 5);

      final rows = await database.select(database.readingEvents).get();
      expect(rows.length, 1);
      expect(rows.single.activityDate, '2026-10-17');
      expect(rows.single.book, 'genesis');
      expect(rows.single.chapter, 1);
      expect(rows.single.verseCount, 20);
    });

    test('stores independent rows per day, book and chapter', () async {
      await dataSource.markReadingEvent('2026-10-17', 'genesis', 1, 10);
      await dataSource.markReadingEvent('2026-10-18', 'genesis', 1, 3);
      await dataSource.markReadingEvent('2026-10-17', 'john', 3, 25);

      final rows = await database.select(database.readingEvents).get();
      expect(rows.length, 3);
    });
  });

  group('getReadingDayTotals', () {
    test(
      'sums the max verse counts and counts distinct chapters per day',
      () async {
        await dataSource.markReadingEvent('2026-10-17', 'genesis', 1, 10);
        await dataSource.markReadingEvent('2026-10-17', 'genesis', 1, 20);
        await dataSource.markReadingEvent('2026-10-17', 'john', 3, 25);
        await dataSource.markReadingEvent('2026-10-16', 'genesis', 2, 4);
        await dataSource.markReadingEvent('2026-10-15', 'genesis', 1, 9);

        final totals = await dataSource.getReadingDayTotals([
          '2026-10-13',
          '2026-10-16',
          '2026-10-17',
        ]);

        final byDate = {for (final total in totals) total.date: total};
        expect(totals.length, 2);
        expect(byDate['2026-10-17']!.chaptersCount, 2);
        expect(byDate['2026-10-17']!.versesCount, 45);
        expect(byDate['2026-10-16']!.chaptersCount, 1);
        expect(byDate['2026-10-16']!.versesCount, 4);
        expect(byDate['2026-10-16']!.hasRead, isTrue);
        expect(byDate.containsKey('2026-10-13'), isFalse);
      },
    );

    test('returns an empty list when no dates are requested', () async {
      expect(await dataSource.getReadingDayTotals(const []), isEmpty);
    });
  });

  group('daily verse', () {
    test('saved row matches the persisted day only', () async {
      await dataSource.importRV1960(verses);

      final random = await dataSource.getRandomVerse();
      expect(random.text, isNotEmpty);

      await dataSource.saveDailyVerse(random, '2026-10-17');

      final saved = await dataSource.getSavedDailyVerse('2026-10-17');
      expect(saved, isNotNull);
      expect(saved!.book, random.book);
      expect(saved.chapter, random.chapter);
      expect(saved.verse, random.verse);

      expect(await dataSource.getSavedDailyVerse('2026-10-18'), isNull);
    });
  });

  test(
    'countCompletedChapters counts only completed chapters of the book',
    () async {
      await dataSource.saveChapterProgress(
        ChapterProgressEntity(
          book: 'genesis',
          chapter: 1,
          lastVerseRead: 31,
          isComplete: true,
          completedAt: DateTime(2026, 10, 17),
        ),
      );
      await dataSource.saveChapterProgress(
        ChapterProgressEntity(
          book: 'genesis',
          chapter: 2,
          lastVerseRead: 5,
          isComplete: false,
        ),
      );
      await dataSource.saveChapterProgress(
        ChapterProgressEntity(
          book: 'john',
          chapter: 1,
          lastVerseRead: 51,
          isComplete: true,
          completedAt: DateTime(2026, 10, 17),
        ),
      );

      expect(await dataSource.countCompletedChapters('genesis'), 1);
      expect(await dataSource.countCompletedChapters('john'), 1);
      expect(await dataSource.countCompletedChapters('jude'), 0);
    },
  );
}
