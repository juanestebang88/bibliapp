import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_cubit.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_state.dart';
import 'package:bibliapp/features/reading/domain/entities/continue_reading_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/count_completed_chapters.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_continue_reading.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_daily_verse.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_recent_reading_days.dart';

class _MockGetDailyVerse extends Mock implements GetDailyVerse {}

class _MockGetContinueReading extends Mock implements GetContinueReading {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockCountCompletedChapters extends Mock
    implements CountCompletedChapters {}

class _MockGetRecentReadingDays extends Mock implements GetRecentReadingDays {}

void main() {
  late _MockGetDailyVerse getDailyVerse;
  late _MockGetContinueReading getContinueReading;
  late _MockGetChapterCount getChapterCount;
  late _MockCountCompletedChapters countCompletedChapters;
  late _MockGetRecentReadingDays getRecentReadingDays;

  const dailyVerse = DailyVerseEntity(
    book: 'john',
    chapter: 3,
    verse: 16,
    text: 'Test verse text',
  );
  const readingDays = [
    ReadingDayEntity(date: '2026-10-13', chaptersCount: 0, versesCount: 0),
    ReadingDayEntity(date: '2026-10-14', chaptersCount: 1, versesCount: 10),
    ReadingDayEntity(date: '2026-10-15', chaptersCount: 0, versesCount: 0),
    ReadingDayEntity(date: '2026-10-16', chaptersCount: 0, versesCount: 0),
    ReadingDayEntity(date: '2026-10-17', chaptersCount: 1, versesCount: 5),
  ];

  setUpAll(() {
    registerFallbackValue(
      const ContinueReadingEntity(book: 'genesis', chapter: 1),
    );
  });

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
      (_) async => const Right<Failure, DailyVerseEntity>(dailyVerse),
    );
    when(() => getChapterCount(any()))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => countCompletedChapters(any()))
        .thenAnswer((_) async => const Right<Failure, int>(2));
    when(() => getRecentReadingDays()).thenAnswer(
      (_) async => const Right<Failure, List<ReadingDayEntity>>(readingDays),
    );
  });

  HomeCubit createCubit() => HomeCubit(
    getDailyVerse: getDailyVerse,
    getContinueReading: getContinueReading,
    getChapterCount: getChapterCount,
    countCompletedChapters: countCompletedChapters,
    getRecentReadingDays: getRecentReadingDays,
  );

  group('initialize', () {
    blocTest<HomeCubit, HomeState>(
      'emits loading and then success with all the data',
      build: createCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.success,
          dailyVerse: dailyVerse,
          continueLocation: ContinueReadingEntity(book: 'genesis', chapter: 3),
          continueBook: 'genesis',
          chaptersCompleted: 2,
          chapterCount: 50,
          readingDays: readingDays,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'falls back to genesis 1 when nothing is marked yet',
      setUp: () {
        when(() => getContinueReading()).thenAnswer(
          (_) async => const Right<Failure, ContinueReadingEntity?>(null),
        );
      },
      build: createCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.success,
          dailyVerse: dailyVerse,
          continueBook: 'genesis',
          chaptersCompleted: 2,
          chapterCount: 50,
          readingDays: readingDays,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'queries the book of the continue location',
      setUp: () {
        when(() => getContinueReading()).thenAnswer(
          (_) async => const Right<Failure, ContinueReadingEntity?>(
            ContinueReadingEntity(
              book: 'exodus',
              chapter: 5,
              lastVerseRead: 12,
            ),
          ),
        );
      },
      build: createCubit,
      act: (cubit) => cubit.initialize(),
      verify: (_) {
        verify(() => getChapterCount('exodus')).called(1);
        verify(() => countCompletedChapters('exodus')).called(1);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'emits failure with a UI-ready message when the repository fails',
      setUp: () {
        when(() => getContinueReading()).thenAnswer(
          (_) async => const Left<Failure, ContinueReadingEntity?>(
            DatabaseFailure('boom'),
          ),
        );
      },
      build: createCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.failure,
          errorMessage: AppStrings.errorLoadingHome,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits failure when one of the parallel queries fails',
      setUp: () {
        when(() => countCompletedChapters(any())).thenAnswer(
          (_) async => const Left<Failure, int>(DatabaseFailure('boom')),
        );
      },
      build: createCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.failure,
          errorMessage: AppStrings.errorLoadingHome,
        ),
      ],
    );
  });
}
