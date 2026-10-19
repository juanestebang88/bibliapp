import 'package:equatable/equatable.dart';

/// Reading state of one book derived from its marks (spec 20).
enum BookReadingStatus { notStarted, inProgress, completed }

/// Per-book reading summary derived from ChapterProgress (spec 19).
class BookReadingStatsEntity extends Equatable {
  /// Stable English book id ('genesis').
  final String book;
  final int completedChapters;
  final int totalChapters;

  /// First time the book was ever marked (null when never marked).
  final DateTime? firstMarkAt;

  /// Last time a chapter of the book was completed (null when none).
  final DateTime? lastCompletedAt;

  const BookReadingStatsEntity({
    required this.book,
    required this.completedChapters,
    required this.totalChapters,
    this.firstMarkAt,
    this.lastCompletedAt,
  });

  /// Completed chapters over the real chapter count, 0..1.
  double get progress {
    if (totalChapters <= 0) return 0;
    return (completedChapters / totalChapters).clamp(0.0, 1.0);
  }

  bool get isCompleted =>
      totalChapters > 0 && completedChapters >= totalChapters;

  /// 'notStarted' when the book has no marks and no completed chapters.
  BookReadingStatus get status {
    if (completedChapters <= 0 && firstMarkAt == null) {
      return BookReadingStatus.notStarted;
    }
    if (isCompleted) return BookReadingStatus.completed;
    return BookReadingStatus.inProgress;
  }

  @override
  List<Object?> get props => [
    book,
    completedChapters,
    totalChapters,
    firstMarkAt,
    lastCompletedAt,
  ];
}

/// Aggregated reading numbers for a set of books (spec 19).
class ReadingOverviewEntity extends Equatable {
  final int completedChapters; // of the scope
  final int totalChapters; // of the scope
  final int chaptersYesterday;
  final int chaptersToday;

  /// Calendar days since the scope's first mark, 0 when never marked.
  final int daysSinceFirstMark;
  final int currentWeekChapters; // today-6..today
  final int previousWeekChapters; // today-13..today-7

  const ReadingOverviewEntity({
    this.completedChapters = 0,
    this.totalChapters = 0,
    this.chaptersYesterday = 0,
    this.chaptersToday = 0,
    this.daysSinceFirstMark = 0,
    this.currentWeekChapters = 0,
    this.previousWeekChapters = 0,
  });

  double get overallProgress {
    if (totalChapters <= 0) return 0;
    return (completedChapters / totalChapters).clamp(0.0, 1.0);
  }

  /// Integer percent change of the rolling week vs the previous one.
  /// Zero base with current readings counts as +100%; both zero is 0%.
  int get weeklyChangePercent {
    if (previousWeekChapters == 0) return currentWeekChapters > 0 ? 100 : 0;
    final change =
        (currentWeekChapters - previousWeekChapters) *
        100 /
        previousWeekChapters;
    return change.round();
  }

  @override
  List<Object?> get props => [
    completedChapters,
    totalChapters,
    chaptersYesterday,
    chaptersToday,
    daysSinceFirstMark,
    currentWeekChapters,
    previousWeekChapters,
  ];
}

/// One chart node: distinct chapters marked on a local day (spec 19).
/// Value object without Equatable, mirroring [ReadingDayEntity].
class ChaptersSeriesPointEntity {
  /// Local date key ('yyyy-MM-dd').
  final String date;
  final int chaptersCount;

  const ChaptersSeriesPointEntity({
    required this.date,
    required this.chaptersCount,
  });
}
