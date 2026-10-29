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

  /// True while a tab switch is recalculating the screen (drives the
  /// percentage skeleton). False on initial load, period changes and success.
  final bool isSwitchingTab;

  const StatsState({
    this.status = StatsStatus.initial,
    this.errorMessage = '',
    this.selectedTab = StatsTab.myProgress,
    this.selectedPeriod = StatsPeriod.week,
    this.overview = const ReadingOverviewEntity(),
    this.series = const [],
    this.visibleBooks = const [],
    this.isSwitchingTab = false,
  });

  StatsState copyWith({
    StatsStatus? status,
    String? errorMessage,
    StatsTab? selectedTab,
    StatsPeriod? selectedPeriod,
    ReadingOverviewEntity? overview,
    List<ChaptersSeriesPointEntity>? series,
    List<BookReadingStatsEntity>? visibleBooks,
    bool? isSwitchingTab,
  }) => StatsState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    selectedTab: selectedTab ?? this.selectedTab,
    selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    overview: overview ?? this.overview,
    series: series ?? this.series,
    visibleBooks: visibleBooks ?? this.visibleBooks,
    isSwitchingTab: isSwitchingTab ?? this.isSwitchingTab,
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
    isSwitchingTab,
  ];
}
