import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_books_reading_stats.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapters_series.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_overview.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';

class _MockReadingRepository extends Mock implements ReadingRepository {}

BookReadingStatsEntity _summary({
  required String book,
  int completed = 0,
  int total = 50,
  DateTime? firstMarkAt,
  DateTime? lastCompletedAt,
}) => BookReadingStatsEntity(
  book: book,
  completedChapters: completed,
  totalChapters: total,
  firstMarkAt: firstMarkAt,
  lastCompletedAt: lastCompletedAt,
);

void main() {
  late _MockReadingRepository repository;

  setUp(() {
    repository = _MockReadingRepository();
    registerFallbackValue(const DatabaseFailure('test'));
  });

  group('GetBooksReadingStats', () {
    test(
      'fills every canon book in canonical order, zeroing missing ones',
      () async {
        when(() => repository.getBookReadingSummaries()).thenAnswer(
          (_) async => Right([
            _summary(book: 'genesis', completed: 11, total: 50),
            _summary(book: 'revelation', completed: 1, total: 22),
          ]),
        );

        final result = await GetBooksReadingStats(repository)();

        final books = result.fold((_) => <BookReadingStatsEntity>[], (v) => v);
        expect(books.first.book, 'genesis');
        expect(books.last.book, 'revelation');
        expect(books.length, 66);
        // Books without data keep the zeroed counters.
        expect(books[0].totalChapters, 50);
        final missingIndex = books.indexWhere((book) => book.book == 'exodus');
        expect(books[missingIndex].completedChapters, 0);
        expect(books[missingIndex].totalChapters, 0);
        expect(books[missingIndex].progress, 0);
      },
    );

    test('propagates repository failures', () async {
      when(
        () => repository.getBookReadingSummaries(),
      ).thenAnswer((_) async => const Left(DatabaseFailure('db unavailable')));

      final result = await GetBooksReadingStats(repository)();

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetReadingOverview', () {
    test(
      'computes scope totals, yesterday vs today and rolling weeks',
      () async {
        when(() => repository.getBookReadingSummaries()).thenAnswer(
          (_) async => Right([
            _summary(
              book: 'genesis',
              completed: 11,
              firstMarkAt: DateTime(2026, 10, 1),
            ),
            _summary(
              book: 'exodus',
              completed: 5,
              total: 40,
              firstMarkAt: DateTime(2026, 9, 20),
            ),
          ]),
        );
        when(
          () => repository.getDailyChaptersCounts(
            dates: any(named: 'dates'),
            books: any(named: 'books'),
          ),
        ).thenAnswer(
          (_) async => Right(const [
            // 2026-10-06 is exactly today-13 (rolling previous week end).
            ChaptersSeriesPointEntity(date: '2026-10-07', chaptersCount: 2),
            ChaptersSeriesPointEntity(date: '2026-10-09', chaptersCount: 3),
            ChaptersSeriesPointEntity(date: '2026-10-13', chaptersCount: 5),
            ChaptersSeriesPointEntity(date: '2026-10-18', chaptersCount: 4),
            ChaptersSeriesPointEntity(date: '2026-10-19', chaptersCount: 6),
            ChaptersSeriesPointEntity(date: '2026-10-20', chaptersCount: 8),
          ]),
        );

        final result = await GetReadingOverview(repository)(const [
          'genesis',
          'exodus',
        ], today: DateTime(2026, 10, 20));

        final overview = result.fold((_) => null, (value) => value);
        expect(overview, isNotNull);
        expect(overview!.completedChapters, 16);
        expect(overview.totalChapters, 90);
        expect(overview.chaptersYesterday, 6);
        expect(overview.chaptersToday, 8);
        // 14-day window: previous week = 2+3+5 = 10, current week = 18.
        expect(overview.previousWeekChapters, 10);
        expect(overview.currentWeekChapters, 18);
        expect(overview.weeklyChangePercent, 80);
        // First mark 2026-09-20 → 30 calendar days until 2026-10-20.
        expect(overview.daysSinceFirstMark, 30);
        expect(overview.overallProgress, closeTo(16 / 90, 0.0001));
      },
    );

    test('ignores books outside the requested scope', () async {
      when(() => repository.getBookReadingSummaries()).thenAnswer(
        (_) async => Right([
          _summary(book: 'genesis', completed: 3),
          _summary(book: 'matthew', completed: 10, total: 28),
        ]),
      );
      when(
        () => repository.getDailyChaptersCounts(
          dates: any(named: 'dates'),
          books: any(named: 'books'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await GetReadingOverview(repository)(const [
        'genesis',
      ], today: DateTime(2026, 10, 20));

      final overview = result.fold((_) => null, (value) => value);
      expect(overview!.totalChapters, 50);
      expect(overview.completedChapters, 3);
    });

    test(
      'zero base with current readings counts as +100 and both zero as 0',
      () async {
        when(() => repository.getBookReadingSummaries()).thenAnswer(
          (_) async => Right([
            _summary(book: 'genesis', firstMarkAt: DateTime(2026, 10, 19)),
          ]),
        );
        when(
          () => repository.getDailyChaptersCounts(
            dates: any(named: 'dates'),
            books: any(named: 'books'),
          ),
        ).thenAnswer(
          (_) async => Right(const [
            ChaptersSeriesPointEntity(date: '2026-10-20', chaptersCount: 2),
          ]),
        );

        final overview = (await GetReadingOverview(repository)(const [
          'genesis',
        ], today: DateTime(2026, 10, 20))).fold((_) => null, (value) => value)!;

        expect(overview.previousWeekChapters, 0);
        expect(overview.currentWeekChapters, 2);
        expect(overview.weeklyChangePercent, 100);
        expect(overview.daysSinceFirstMark, 1);
      },
    );

    test('marks from today give a 0-day duration', () async {
      when(() => repository.getBookReadingSummaries()).thenAnswer(
        (_) async => Right([
          _summary(book: 'genesis', firstMarkAt: DateTime(2026, 10, 20, 8)),
        ]),
      );
      when(
        () => repository.getDailyChaptersCounts(
          dates: any(named: 'dates'),
          books: any(named: 'books'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final overview = (await GetReadingOverview(repository)(const [
        'genesis',
      ], today: DateTime(2026, 10, 20))).fold((_) => null, (value) => value)!;

      expect(overview.daysSinceFirstMark, 0);
      expect(overview.weeklyChangePercent, 0);
    });

    test('propagates repository failures', () async {
      when(
        () => repository.getBookReadingSummaries(),
      ).thenAnswer((_) async => const Left(DatabaseFailure('db unavailable')));
      when(
        () => repository.getDailyChaptersCounts(
          dates: any(named: 'dates'),
          books: any(named: 'books'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await GetReadingOverview(repository)(const ['genesis']);

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetChaptersSeries', () {
    test(
      'fills every day of the range with zeros when there are no marks',
      () async {
        when(
          () => repository.getDailyChaptersCounts(
            dates: any(named: 'dates'),
            books: any(named: 'books'),
          ),
        ).thenAnswer((_) async => const Right([]));

        final result = await GetChaptersSeries(repository)(
          books: const ['genesis'],
          from: DateTime(2026, 10, 14),
          to: DateTime(2026, 10, 20),
        );

        final series = result.fold(
          (_) => <ChaptersSeriesPointEntity>[],
          (v) => v,
        );
        expect(series.length, 7);
        expect(series.first.date, '2026-10-14');
        expect(series.last.date, '2026-10-20');
        expect(series.every((point) => point.chaptersCount == 0), isTrue);
      },
    );

    test('keeps the queried counts and fills the gaps in between', () async {
      when(
        () => repository.getDailyChaptersCounts(
          dates: any(named: 'dates'),
          books: any(named: 'books'),
        ),
      ).thenAnswer(
        (_) async => Right(const [
          ChaptersSeriesPointEntity(date: '2026-10-15', chaptersCount: 3),
          ChaptersSeriesPointEntity(date: '2026-10-19', chaptersCount: 1),
        ]),
      );

      final result = await GetChaptersSeries(repository)(
        books: const ['genesis'],
        from: DateTime(2026, 10, 14),
        to: DateTime(2026, 10, 20),
      );

      final series = result.fold(
        (_) => <ChaptersSeriesPointEntity>[],
        (v) => v,
      );
      expect(series.length, 7);
      expect(series[1].chaptersCount, 3);
      expect(series[5].chaptersCount, 1);
      expect(series[3].chaptersCount, 0);
    });

    test('returns an empty series for an inverted range', () async {
      final result = await GetChaptersSeries(repository)(
        books: const ['genesis'],
        from: DateTime(2026, 10, 20),
        to: DateTime(2026, 10, 14),
      );

      expect(result.fold((_) => -1, (series) => series.length), 0);
      verifyNever(
        () => repository.getDailyChaptersCounts(
          dates: any(named: 'dates'),
          books: any(named: 'books'),
        ),
      );
    });
  });
}
