import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/domain/book_order.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_books_reading_stats.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapters_series.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_overview.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_state.dart';

class _MockGetReadingOverview extends Mock implements GetReadingOverview {}

class _MockGetChaptersSeries extends Mock implements GetChaptersSeries {}

class _MockGetBooksReadingStats extends Mock implements GetBooksReadingStats {}

void main() {
  late _MockGetReadingOverview getReadingOverview;
  late _MockGetChaptersSeries getChaptersSeries;
  late _MockGetBooksReadingStats getBooksReadingStats;

  final genesisBook = BookReadingStatsEntity(
    book: 'genesis',
    completedChapters: 4,
    totalChapters: 50,
    firstMarkAt: DateTime(2026, 9, 1),
  );
  final malachiBook = BookReadingStatsEntity(
    book: 'malachi',
    completedChapters: 2,
    totalChapters: 4,
    firstMarkAt: DateTime(2026, 8, 15),
  );
  const revelationBook = BookReadingStatsEntity(
    book: 'revelation',
    completedChapters: 1,
    totalChapters: 22,
  );

  final allBookStats = [genesisBook, malachiBook, revelationBook];
  final oldTestamentBookStats = [genesisBook, malachiBook];

  const overview = ReadingOverviewEntity(
    completedChapters: 7,
    totalChapters: 76,
    chaptersYesterday: 1,
    chaptersToday: 2,
    daysSinceFirstMark: 30,
    currentWeekChapters: 5,
    previousWeekChapters: 4,
  );

  final weekSeries = [
    for (var day = 14; day <= 20; day++)
      ChaptersSeriesPointEntity(date: '2026-10-$day', chaptersCount: day - 14),
  ];
  final monthSeries = [
    for (var day = 1; day <= 30; day++)
      ChaptersSeriesPointEntity(
        date: '2026-09-${day.toString().padLeft(2, '0')}',
        chaptersCount: day,
      ),
  ];

  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    getReadingOverview = _MockGetReadingOverview();
    getChaptersSeries = _MockGetChaptersSeries();
    getBooksReadingStats = _MockGetBooksReadingStats();

    when(
      () => getReadingOverview(any(), today: any(named: 'today')),
    ).thenAnswer((_) async => Right<Failure, ReadingOverviewEntity>(overview));
    when(
      () => getChaptersSeries(
        books: any(named: 'books'),
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer(
      (_) async => Right<Failure, List<ChaptersSeriesPointEntity>>(weekSeries),
    );
    when(() => getBooksReadingStats()).thenAnswer(
      (_) async => Right<Failure, List<BookReadingStatsEntity>>(allBookStats),
    );
  });

  StatsCubit createCubit() => StatsCubit(
    getReadingOverview: getReadingOverview,
    getChaptersSeries: getChaptersSeries,
    getBooksReadingStats: getBooksReadingStats,
  );

  group('initialize', () {
    DateTime todayDate() {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day);
    }

    blocTest<StatsCubit, StatsState>(
      'emits loading and then success with the week series and every book',
      build: createCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const StatsState(status: StatsStatus.loading),
        StatsState(
          status: StatsStatus.success,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
        ),
      ],
      verify: (_) {
        final captured = verify(
          () => getChaptersSeries(
            books: captureAny(named: 'books'),
            from: captureAny(named: 'from'),
            to: captureAny(named: 'to'),
          ),
        ).captured;
        expect(captured[0], bibleBookOrder);
        expect(captured[0], contains('genesis'));
        expect(captured[1], todayDate().subtract(const Duration(days: 6)));
        expect(captured[2], todayDate());
      },
    );

    blocTest<StatsCubit, StatsState>(
      'emits failure with a UI-ready message when the overview fails',
      setUp: () {
        when(() => getReadingOverview(any(), today: any(named: 'today')))
            .thenAnswer(
              (_) async =>
                  Left<Failure, ReadingOverviewEntity>(DatabaseFailure('boom')),
            );
      },
      build: createCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const StatsState(status: StatsStatus.loading),
        const StatsState(
          status: StatsStatus.failure,
          errorMessage: AppStrings.errorLoadingStats,
        ),
      ],
    );
  });

  group('selectTab', () {
    blocTest<StatsCubit, StatsState>(
      'reloads for the new tab, keeps the skeleton at least 400 ms and clears '
      'the flag at the end',
      build: createCubit,
      act: (cubit) async {
        await cubit.initialize();
        final stopwatch = Stopwatch()..start();
        await cubit.selectTab(StatsTab.oldTestament);
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(400));
      },
      expect: () => [
        const StatsState(status: StatsStatus.loading),
        StatsState(
          status: StatsStatus.success,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
        ),
        // Previous data stays visible while the skeleton runs (no spinner).
        StatsState(
          status: StatsStatus.success,
          selectedTab: StatsTab.oldTestament,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
          isSwitchingTab: true,
        ),
        StatsState(
          status: StatsStatus.success,
          selectedTab: StatsTab.oldTestament,
          overview: overview,
          series: weekSeries,
          visibleBooks: oldTestamentBookStats,
          isSwitchingTab: true,
        ),
        StatsState(
          status: StatsStatus.success,
          selectedTab: StatsTab.oldTestament,
          overview: overview,
          series: weekSeries,
          visibleBooks: oldTestamentBookStats,
        ),
      ],
      verify: (_) {
        final captured = verify(
          () => getReadingOverview(captureAny(), today: any(named: 'today')),
        ).captured;
        expect(captured.length, 2);
        expect(captured.last, oldTestamentBooks);
      },
    );

    blocTest<StatsCubit, StatsState>(
      'clears the switching flag when the tab reload fails',
      build: createCubit,
      act: (cubit) async {
        await cubit.initialize();
        when(() => getReadingOverview(any(), today: any(named: 'today')))
            .thenAnswer(
              (_) async =>
                  Left<Failure, ReadingOverviewEntity>(DatabaseFailure('boom')),
            );
        await cubit.selectTab(StatsTab.oldTestament);
      },
      expect: () => [
        const StatsState(status: StatsStatus.loading),
        StatsState(
          status: StatsStatus.success,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
        ),
        StatsState(
          status: StatsStatus.success,
          selectedTab: StatsTab.oldTestament,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
          isSwitchingTab: true,
        ),
        StatsState(
          status: StatsStatus.failure,
          errorMessage: AppStrings.errorLoadingStats,
          selectedTab: StatsTab.oldTestament,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
          isSwitchingTab: true,
        ),
        StatsState(
          status: StatsStatus.failure,
          errorMessage: AppStrings.errorLoadingStats,
          selectedTab: StatsTab.oldTestament,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
        ),
      ],
    );

    blocTest<StatsCubit, StatsState>(
      'does nothing when the selected tab is already active',
      build: createCubit,
      act: (cubit) async {
        await cubit.initialize();
        await cubit.selectTab(StatsTab.myProgress);
      },
      expect: () => [
        const StatsState(status: StatsStatus.loading),
        StatsState(
          status: StatsStatus.success,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
        ),
      ],
      verify: (_) {
        final captured = verify(
          () => getReadingOverview(captureAny(), today: any(named: 'today')),
        ).captured;
        expect(captured.length, 1);
      },
    );
  });

  group('selectPeriod', () {
    blocTest<StatsCubit, StatsState>(
      'reloads only the series; overview and visible books stay untouched',
      setUp: () {
        var seriesCalls = 0;
        when(
          () => getChaptersSeries(
            books: any(named: 'books'),
            from: any(named: 'from'),
            to: any(named: 'to'),
          ),
        ).thenAnswer((_) async {
          seriesCalls++;
          return Right<Failure, List<ChaptersSeriesPointEntity>>(
            seriesCalls == 1 ? weekSeries : monthSeries,
          );
        });
      },
      build: createCubit,
      act: (cubit) async {
        await cubit.initialize();
        await cubit.selectPeriod(StatsPeriod.month);
      },
      expect: () => [
        const StatsState(status: StatsStatus.loading),
        StatsState(
          status: StatsStatus.success,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
        ),
        // Overview and books keep their previous data while switching.
        StatsState(
          status: StatsStatus.success,
          selectedPeriod: StatsPeriod.month,
          overview: overview,
          series: weekSeries,
          visibleBooks: allBookStats,
        ),
        StatsState(
          status: StatsStatus.success,
          selectedPeriod: StatsPeriod.month,
          overview: overview,
          series: monthSeries,
          visibleBooks: allBookStats,
        ),
      ],
      verify: (_) {
        // The overview is only queried once (by initialize), never again.
        verify(() => getReadingOverview(any(), today: any(named: 'today')))
            .called(1);

        final captured = verify(
          () => getChaptersSeries(
            books: captureAny(named: 'books'),
            from: captureAny(named: 'from'),
            to: captureAny(named: 'to'),
          ),
        ).captured;
        final now = DateTime.now();
        final todayDate = DateTime(now.year, now.month, now.day);
        expect(captured[0], bibleBookOrder);
        expect(captured[3], bibleBookOrder);
        expect(captured[4], todayDate.subtract(const Duration(days: 29)));
        expect(captured[5], todayDate);
      },
    );
  });
}
