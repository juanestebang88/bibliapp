import 'package:equatable/equatable.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

enum StatsStatus { initial, loading, success, failure }

enum StatsTab { myProgress, oldTestament, newTestament }

enum StatsPeriod { week, month }

class StatsState extends Equatable {
  final StatsStatus status;
  final String errorMessage; // UI-ready message
  final StatsTab selectedTab; // myProgress by default
  final StatsPeriod selectedPeriod; // week by default
  final ReadingOverviewEntity overview;
  final List<ChaptersSeriesPointEntity> series; // 7 or 30 points, filled
  final List<BookReadingStatsEntity> visibleBooks; // filtered by selectedTab

  /// Book shown in the detail bottom sheet (null when closed).
  final BookReadingStatsEntity? selectedBook;
  final List<ChaptersSeriesPointEntity> selectedBookSeries;
  final bool isLoadingBookDetail;

  const StatsState({
    this.status = StatsStatus.initial,
    this.errorMessage = '',
    this.selectedTab = StatsTab.myProgress,
    this.selectedPeriod = StatsPeriod.week,
    this.overview = const ReadingOverviewEntity(),
    this.series = const [],
    this.visibleBooks = const [],
    this.selectedBook,
    this.selectedBookSeries = const [],
    this.isLoadingBookDetail = false,
  });

  StatsState copyWith({
    StatsStatus? status,
    String? errorMessage,
    StatsTab? selectedTab,
    StatsPeriod? selectedPeriod,
    ReadingOverviewEntity? overview,
    List<ChaptersSeriesPointEntity>? series,
    List<BookReadingStatsEntity>? visibleBooks,
    BookReadingStatsEntity? selectedBook,
    List<ChaptersSeriesPointEntity>? selectedBookSeries,
    bool? isLoadingBookDetail,
    bool clearSelectedBook = false,
  }) => StatsState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    selectedTab: selectedTab ?? this.selectedTab,
    selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    overview: overview ?? this.overview,
    series: series ?? this.series,
    visibleBooks: visibleBooks ?? this.visibleBooks,
    selectedBook: clearSelectedBook ? null : selectedBook ?? this.selectedBook,
    selectedBookSeries: selectedBookSeries ?? this.selectedBookSeries,
    isLoadingBookDetail: isLoadingBookDetail ?? this.isLoadingBookDetail,
  );

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    selectedTab,
    selectedPeriod,
    overview,
    series,
    visibleBooks,
    selectedBook,
    selectedBookSeries,
    isLoadingBookDetail,
  ];
}
