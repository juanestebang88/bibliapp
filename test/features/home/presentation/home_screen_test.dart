import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_cubit.dart';
import 'package:bibliapp/features/home/presentation/pages/home_screen.dart';
import 'package:bibliapp/features/home/presentation/widgets/home_error_view.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/continue_reading_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/count_completed_chapters.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_daily_verse.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_continue_reading.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_recent_reading_days.dart';

class _MockGetDailyVerse extends Mock implements GetDailyVerse {}

class _MockGetContinueReading extends Mock implements GetContinueReading {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockCountCompletedChapters extends Mock
    implements CountCompletedChapters {}

class _MockGetRecentReadingDays extends Mock implements GetRecentReadingDays {}

const _dailyVerse = DailyVerseEntity(
  book: 'john',
  chapter: 3,
  verse: 16,
  text: 'Test verse text',
);

void main() {
  late _MockGetDailyVerse getDailyVerse;
  late _MockGetContinueReading getContinueReading;
  late _MockGetChapterCount getChapterCount;
  late _MockCountCompletedChapters countCompletedChapters;
  late _MockGetRecentReadingDays getRecentReadingDays;

  setUp(() {
    getDailyVerse = _MockGetDailyVerse();
    getContinueReading = _MockGetContinueReading();
    getChapterCount = _MockGetChapterCount();
    countCompletedChapters = _MockCountCompletedChapters();
    getRecentReadingDays = _MockGetRecentReadingDays();

    when(() => getContinueReading()).thenAnswer(
      (_) async => const Right<Failure, ContinueReadingEntity?>(
        ContinueReadingEntity(book: 'genesis', chapter: 3),
      ),
    );
    when(() => getDailyVerse()).thenAnswer(
      (_) async => const Right<Failure, DailyVerseEntity>(_dailyVerse),
    );
    when(() => getChapterCount(any()))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => countCompletedChapters(any()))
        .thenAnswer((_) async => const Right<Failure, int>(2));
    when(() => getRecentReadingDays()).thenAnswer(
      (_) async => const Right<Failure, List<ReadingDayEntity>>([
        ReadingDayEntity(date: '2026-10-13', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-14', chaptersCount: 1, versesCount: 5),
        ReadingDayEntity(date: '2026-10-15', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-16', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-17', chaptersCount: 2, versesCount: 12),
      ]),
    );
  });

  Widget buildApp(HomeCubit cubit) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, _) => BlocProvider<HomeCubit>.value(
            value: cubit,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/reading',
          builder: (context, _) => const Scaffold(body: Text('reading-body')),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, _) => const Scaffold(body: Text('stats-body')),
        ),
      ],
    );
    return MaterialApp.router(theme: ThemeData(), routerConfig: router);
  }

  Future<void> pumpReady(WidgetTester tester) async {
    final cubit = HomeCubit(
      getDailyVerse: getDailyVerse,
      getContinueReading: getContinueReading,
      getChapterCount: getChapterCount,
      countCompletedChapters: countCompletedChapters,
      getRecentReadingDays: getRecentReadingDays,
    );
    await cubit.initialize();
    await tester.pumpWidget(buildApp(cubit));
    await tester.pumpAndSettle();
    addTearDown(cubit.close);
  }

  testWidgets('shows the three cards after loading', (tester) async {
    await pumpReady(tester);
    await tester.pump();

    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text(_dailyVerse.text), findsOneWidget);
    expect(find.text(AppStrings.chaptersReadSummary(2, 50)), findsOneWidget);
    expect(find.text(AppStrings.today), findsOneWidget);
    expect(find.text(AppStrings.continueReading), findsOneWidget);
  });

  testWidgets('toolbar "Lectura" navigates to /reading', (tester) async {
    await pumpReady(tester);
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text(AppStrings.reading));
    await tester.pumpAndSettle();

    expect(find.text('reading-body'), findsOneWidget);
  });

  testWidgets('toolbar "Estadísticas" navigates to /stats', (tester) async {
    await pumpReady(tester);
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text(AppStrings.statistics));
    await tester.pumpAndSettle();

    expect(find.text('stats-body'), findsOneWidget);
  });

  testWidgets('shows HomeErrorView on failure and recovers on retry', (
    tester,
  ) async {
    when(() => getContinueReading()).thenAnswer(
      (_) async =>
          const Left<Failure, ContinueReadingEntity?>(DatabaseFailure('boom')),
    );

    final cubit = HomeCubit(
      getDailyVerse: getDailyVerse,
      getContinueReading: getContinueReading,
      getChapterCount: getChapterCount,
      countCompletedChapters: countCompletedChapters,
      getRecentReadingDays: getRecentReadingDays,
    );
    await cubit.initialize();
    await tester.pumpWidget(buildApp(cubit));
    await tester.pumpAndSettle();
    addTearDown(cubit.close);

    expect(find.byType(HomeErrorView), findsOneWidget);
    expect(find.text(AppStrings.errorLoadingHome), findsOneWidget);

    when(() => getContinueReading()).thenAnswer(
      (_) async => const Right<Failure, ContinueReadingEntity?>(
        ContinueReadingEntity(book: 'genesis', chapter: 3),
      ),
    );

    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(HomeErrorView), findsNothing);
    expect(find.text(_dailyVerse.text), findsOneWidget);
  });
}
