import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_state.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/count_completed_chapters.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_continue_reading.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_daily_verse.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_recent_reading_days.dart';

/// Orchestrates all the home screen data. Every mount re-queries the daily
/// verse and the recent reading days, so "today" turns green as soon as the
/// user marks progress and comes back.
class HomeCubit extends Cubit<HomeState> {
  final GetDailyVerse getDailyVerse;
  final GetContinueReading getContinueReading;
  final GetChapterCount getChapterCount;
  final CountCompletedChapters countCompletedChapters;
  final GetRecentReadingDays getRecentReadingDays;

  HomeCubit({
    required this.getDailyVerse,
    required this.getContinueReading,
    required this.getChapterCount,
    required this.countCompletedChapters,
    required this.getRecentReadingDays,
  }) : super(const HomeState());

  Future<void> initialize() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: ''));

    final continueResult = await getContinueReading();
    if (continueResult.isLeft()) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: AppStrings.errorLoadingHome,
        ),
      );
      return;
    }
    final continueLocation = continueResult.getRight().toNullable();
    final book = continueLocation?.book ?? 'genesis';

    final results = await Future.wait([
      getDailyVerse(),
      getChapterCount(book),
      countCompletedChapters(book),
      getRecentReadingDays(),
    ]);

    String? failureMessage;
    DailyVerseEntity? dailyVerse;
    var chapterCount = 0;
    var chaptersCompleted = 0;
    var readingDays = const <ReadingDayEntity>[];

    void collect<E>(Either<Failure, E> result, void Function(E) onSuccess) {
      result.match(
        (_) => failureMessage ??= AppStrings.errorLoadingHome,
        onSuccess,
      );
    }

    collect(
      results[0] as Either<Failure, DailyVerseEntity>,
      (value) => dailyVerse = value,
    );
    collect(
      results[1] as Either<Failure, int>,
      (value) => chapterCount = value,
    );
    collect(
      results[2] as Either<Failure, int>,
      (value) => chaptersCompleted = value,
    );
    collect(
      results[3] as Either<Failure, List<ReadingDayEntity>>,
      (value) => readingDays = value,
    );

    if (failureMessage != null) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failureMessage!,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: HomeStatus.success,
        errorMessage: '',
        dailyVerse: dailyVerse,
        continueLocation: continueLocation,
        clearContinueLocation: continueLocation == null,
        continueBook: book,
        chaptersCompleted: chaptersCompleted,
        chapterCount: chapterCount,
        readingDays: readingDays,
      ),
    );
  }
}
