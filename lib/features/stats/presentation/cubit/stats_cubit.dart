import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/reading/domain/book_order.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_books_reading_stats.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapters_series.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_overview.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_state.dart';

/// Orchestrates the stats screen: re-queries everything on every mount and
/// recalculates the whole screen when the tab changes. While a tab or the
/// period is switching, the previous data stays visible (no spinner).
class StatsCubit extends Cubit<StatsState> {
  final GetReadingOverview getReadingOverview;
  final GetChaptersSeries getChaptersSeries;
  final GetBooksReadingStats getBooksReadingStats;

  StatsCubit({
    required this.getReadingOverview,
    required this.getChaptersSeries,
    required this.getBooksReadingStats,
  }) : super(const StatsState());

  Future<void> initialize() async {
    emit(state.copyWith(status: StatsStatus.loading, errorMessage: ''));
    await _load();
  }

  Future<void> retry() => initialize();

  Future<void> selectTab(StatsTab tab) async {
    if (tab == state.selectedTab) return;
    emit(state.copyWith(selectedTab: tab));
    await _load();
  }

  Future<void> selectPeriod(StatsPeriod period) async {
    if (period == state.selectedPeriod) return;
    emit(state.copyWith(selectedPeriod: period));
    await _loadSeries();
  }

  /// Opens the per-book detail sheet: series per day since the book's first
  /// mark up to today. Books without marks load no series at all.
  Future<void> openBook(BookReadingStatsEntity book) async {
    emit(
      state.copyWith(
        selectedBook: book,
        selectedBookSeries: const [],
        isLoadingBookDetail: true,
      ),
    );
    final firstMark = book.firstMarkAt;
    if (firstMark == null) {
      emit(state.copyWith(isLoadingBookDetail: false));
      return;
    }
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final firstMarkDate = DateTime(
      firstMark.year,
      firstMark.month,
      firstMark.day,
    );
    if (firstMarkDate.isAfter(nowDate)) {
      emit(state.copyWith(isLoadingBookDetail: false));
      return;
    }

    final seriesResult = await getChaptersSeries(
      books: [book.book],
      from: firstMarkDate,
      to: nowDate,
    );
    seriesResult.fold(
      (failure) => emit(_failureState()),
      (series) => emit(
        state.copyWith(isLoadingBookDetail: false, selectedBookSeries: series),
      ),
    );
  }

  void closeBook() => emit(state.copyWith(clearSelectedBook: true));

  Future<void> _load() async {
    final books = _booksForTab(state.selectedTab);
    final today = DateTime.now();
    final nowDate = DateTime(today.year, today.month, today.day);
    final from = nowDate.subtract(
      Duration(days: state.selectedPeriod == StatsPeriod.week ? 6 : 29),
    );

    final results = await Future.wait([
      getReadingOverview(books),
      getChaptersSeries(books: books, from: from, to: nowDate),
      getBooksReadingStats(),
    ]);

    String? failureMessage;
    ReadingOverviewEntity? overview;
    List<ChaptersSeriesPointEntity>? series;
    List<BookReadingStatsEntity>? allBooks;

    void collect<E>(Either<Failure, E> result, void Function(E) onSuccess) {
      result.match(
        (_) => failureMessage ??= AppStrings.errorLoadingStats,
        onSuccess,
      );
    }

    collect(
      results[0] as Either<Failure, ReadingOverviewEntity>,
      (value) => overview = value,
    );
    collect(
      results[1] as Either<Failure, List<ChaptersSeriesPointEntity>>,
      (value) => series = value,
    );
    collect(
      results[2] as Either<Failure, List<BookReadingStatsEntity>>,
      (value) => allBooks = value,
    );

    if (failureMessage != null) {
      emit(_failureState(message: failureMessage!));
      return;
    }

    final scope = books.toSet();
    emit(
      state.copyWith(
        status: StatsStatus.success,
        errorMessage: '',
        overview: overview,
        series: series,
        visibleBooks: [
          for (final book in allBooks!)
            if (scope.contains(book.book)) book,
        ],
      ),
    );
  }

  Future<void> _loadSeries() async {
    final books = _booksForTab(state.selectedTab);
    final today = DateTime.now();
    final nowDate = DateTime(today.year, today.month, today.day);
    final from = nowDate.subtract(
      Duration(days: state.selectedPeriod == StatsPeriod.week ? 6 : 29),
    );

    final seriesResult = await getChaptersSeries(
      books: books,
      from: from,
      to: nowDate,
    );
    seriesResult.fold(
      (_) => emit(_failureState()),
      (series) => emit(state.copyWith(series: series)),
    );
  }

  StatsState _failureState({String? message}) => state.copyWith(
    status: StatsStatus.failure,
    errorMessage: message ?? AppStrings.errorLoadingStats,
  );

  List<String> _booksForTab(StatsTab tab) => switch (tab) {
    StatsTab.myProgress => bibleBookOrder,
    StatsTab.oldTestament => oldTestamentBooks,
    StatsTab.newTestament => newTestamentBooks,
  };
}
