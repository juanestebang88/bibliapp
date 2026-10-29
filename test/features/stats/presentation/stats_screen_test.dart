import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/core/widgets/toolbar_action.dart';
import 'package:bibliapp/features/reading/domain/book_order.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_state.dart';
import 'package:bibliapp/features/stats/presentation/pages/stats_screen.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_dialog.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_grid.dart';
import 'package:bibliapp/features/stats/presentation/widgets/duration_tile.dart';
import 'package:bibliapp/features/stats/presentation/widgets/stats_error_view.dart';
import 'package:bibliapp/features/stats/presentation/widgets/weekly_change_tile.dart';

class _MockStatsCubit extends MockBloc<StatsState, StatsState>
    implements StatsCubit {}

const _overview = ReadingOverviewEntity(
  completedChapters: 11,
  totalChapters: 1189,
  chaptersYesterday: 4,
  chaptersToday: 6,
  daysSinceFirstMark: 1,
  currentWeekChapters: 8,
  previousWeekChapters: 7,
);

final _weekSeries = [
  for (var index = 0; index < 7; index++)
    ChaptersSeriesPointEntity(date: '2026-10-1${index + 4}', chaptersCount: 0),
];

final _allBooks = [
  for (final book in bibleBookOrder)
    BookReadingStatsEntity(book: book, completedChapters: 0, totalChapters: 50),
];

Future<void> _pumpScreen(
  WidgetTester tester,
  _MockStatsCubit cubit, {
  StatsState? initialState,
  bool settle = true,
}) async {
  whenListen(
    cubit,
    const Stream<StatsState>.empty(),
    initialState:
        initialState ??
        StatsState(
          status: StatsStatus.success,
          overview: _overview,
          series: _weekSeries,
          visibleBooks: _allBooks,
        ),
  );
  final router = GoRouter(
    initialLocation: '/stats',
    routes: [
      GoRoute(
        path: '/stats',
        builder: (context, state) => BlocProvider<StatsCubit>.value(
          value: cubit,
          child: const StatsScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(body: Text('home-body')),
      ),
      GoRoute(
        path: '/reading',
        builder: (context, state) => const Scaffold(body: Text('reading-body')),
      ),
    ],
  );
  await tester.pumpWidget(
    MaterialApp.router(theme: appTheme(), routerConfig: router),
  );
  // A settled pump hangs while an infinite spinner is on screen; when the
  // caller knows the state stays loading, a single pump suffices.
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

void main() {
  late _MockStatsCubit cubit;

  setUpAll(() {
    registerFallbackValue(StatsTab.myProgress);
    registerFallbackValue(StatsPeriod.week);
    registerFallbackValue(_allBooks.first);
  });

  setUp(() {
    cubit = _MockStatsCubit();
    when(() => cubit.selectTab(any())).thenAnswer((_) async {});
    when(() => cubit.selectPeriod(any())).thenAnswer((_) async {});
    when(() => cubit.openBook(any())).thenAnswer((_) async {});
    when(() => cubit.retry()).thenAnswer((_) async {});
  });

  testWidgets('renders header, donut, quick metrics, chart and book cards', (
    tester,
  ) async {
    await _pumpScreen(tester, cubit);

    expect(find.text(AppStrings.statsTitle), findsOneWidget);
    expect(find.text(AppStrings.tabMyProgress), findsOneWidget);
    expect(find.text('0.9%'), findsOneWidget);
    expect(find.text(AppStrings.yesterdayVsToday), findsOneWidget);
    expect(find.text(AppStrings.chaptersYesterday(4)), findsOneWidget);
    expect(find.text(AppStrings.chaptersToday(6)), findsOneWidget);
    expect(find.text(AppStrings.durationDays(1)), findsOneWidget);
    expect(find.text(AppStrings.durationLabel), findsOneWidget);
    expect(find.text(AppStrings.progressLabel), findsOneWidget);
    expect(find.text(AppStrings.weeklyChange(14)), findsOneWidget);
    expect(find.text(AppStrings.readingsPerWeek), findsOneWidget);
    expect(find.text(AppStrings.chaptersPerDayUnit), findsOneWidget);
    expect(find.text(AppStrings.bookName('genesis')), findsOneWidget);
  });

  testWidgets('DURACIÓN and PROGRESO cards share the same height', (
    tester,
  ) async {
    await _pumpScreen(tester, cubit);

    final durationSize = tester.getSize(find.byType(DurationTile));
    final progressSize = tester.getSize(find.byType(WeeklyChangeTile));

    expect(progressSize.height, greaterThan(0));
    expect(durationSize.height, progressSize.height);
  });

  testWidgets('all three tabs are present in the header', (tester) async {
    await _pumpScreen(tester, cubit);

    expect(find.text(AppStrings.tabMyProgress), findsOneWidget);
    expect(find.text(AppStrings.tabOldTestament), findsOneWidget);
    expect(find.text(AppStrings.tabNewTestament), findsOneWidget);
  });

  testWidgets('the grid receives all 66 canon books for Mi Progreso', (
    tester,
  ) async {
    await _pumpScreen(tester, cubit);

    final grid = tester.widget<BookStatsGrid>(find.byType(BookStatsGrid));
    expect(grid.books.length, 66);
    expect(grid.books.first.book, 'genesis');
    expect(grid.books.last.book, 'revelation');
  });

  testWidgets('switching to Antiguo Testamento scopes the grid to 39 books', (
    tester,
  ) async {
    final otBooks = [
      for (final book in oldTestamentBooks)
        BookReadingStatsEntity(
          book: book,
          completedChapters: 0,
          totalChapters: 40,
        ),
    ];
    await _pumpScreen(
      tester,
      cubit,
      initialState: StatsState(
        status: StatsStatus.success,
        overview: _overview,
        series: _weekSeries,
        visibleBooks: otBooks,
      ),
    );

    final grid = tester.widget<BookStatsGrid>(find.byType(BookStatsGrid));
    expect(grid.books.length, 39);
    expect(
      tester
          .widgetList<BookStatsGrid>(find.byType(BookStatsGrid))
          .first
          .books
          .last
          .book,
      'malachi',
    );
  });

  testWidgets('tapping the AT tab recalculates through the cubit', (
    tester,
  ) async {
    await _pumpScreen(tester, cubit);

    await tester.tap(find.text(AppStrings.tabOldTestament));
    await tester.pumpAndSettle();

    verify(() => cubit.selectTab(StatsTab.oldTestament)).called(1);
  });

  testWidgets('the period selector recalculates the chart through the cubit', (
    tester,
  ) async {
    await _pumpScreen(tester, cubit);

    await tester.tap(find.text(AppStrings.periodMonth));
    await tester.pumpAndSettle();

    verify(() => cubit.selectPeriod(StatsPeriod.month)).called(1);
    verifyNever(() => cubit.selectTab(any()));
  });

  testWidgets('tapping a book card opens its centered detail dialog', (
    tester,
  ) async {
    await _pumpScreen(tester, cubit);

    final genesisLabel = find.text(AppStrings.bookName('genesis'));
    await tester.ensureVisible(genesisLabel.first);
    await tester.pumpAndSettle();

    await tester.tap(genesisLabel.first, warnIfMissed: false);
    await tester.pumpAndSettle();

    verify(() => cubit.openBook(any())).called(1);
    expect(find.byType(BookStatsDialog), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('toolbar uses the canonical order with Estadísticas active', (
    tester,
  ) async {
    await _pumpScreen(tester, cubit);

    final actions = tester
        .widgetList<ToolbarAction>(find.byType(ToolbarAction))
        .toList();

    expect(actions.map((action) => action.label), [
      AppStrings.home,
      AppStrings.reading,
      AppStrings.statistics,
      AppStrings.settings,
    ]);

    final statistics = actions[2];
    expect(statistics.isActive, isTrue);
    expect(statistics.onTap, isNull);

    final settings = actions[3];
    expect(settings.isActive, isFalse);
    expect(settings.onTap, isNull);

    final home = actions[0];
    final reading = actions[1];
    expect(home.isActive, isFalse);
    expect(home.onTap, isNotNull);
    expect(reading.isActive, isFalse);
    expect(reading.onTap, isNotNull);

    await tester.tap(find.text(AppStrings.settings), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Tapping a non-actionable item keeps the stats screen in place.
    expect(find.text(AppStrings.statsTitle), findsOneWidget);
    expect(find.text('home-body'), findsNothing);
    verifyNever(() => cubit.selectTab(any()));
    verifyNever(() => cubit.selectPeriod(any()));
  });

  testWidgets('shows a spinner while the first load runs', (tester) async {
    await _pumpScreen(
      tester,
      cubit,
      initialState: const StatsState(status: StatsStatus.loading),
      settle: false,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('failure shows the error view and retry calls the cubit', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      cubit,
      initialState: const StatsState(
        status: StatsStatus.failure,
        errorMessage: AppStrings.errorLoadingStats,
      ),
    );

    expect(find.byType(StatsErrorView), findsOneWidget);
    expect(find.text(AppStrings.errorLoadingStats), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));

    verify(() => cubit.retry()).called(1);
  });

  testWidgets('toolbar "Inicio" navigates to /home', (tester) async {
    await _pumpScreen(tester, cubit);

    await tester.tap(find.text(AppStrings.home));
    await tester.pumpAndSettle();

    expect(find.text('home-body'), findsOneWidget);
  });

  testWidgets('toolbar "Lectura" navigates to /reading', (tester) async {
    await _pumpScreen(tester, cubit);

    await tester.tap(find.text(AppStrings.reading));
    await tester.pumpAndSettle();

    expect(find.text('reading-body'), findsOneWidget);
  });
}
