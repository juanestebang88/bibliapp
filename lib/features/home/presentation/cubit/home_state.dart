import 'package:equatable/equatable.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String errorMessage; // UI-ready message
  final DailyVerseEntity? dailyVerse;
  final ReadingProgressEntity lastLocation;
  final int chaptersCompleted; // of the current book
  final int chapterCount; // of the current book
  final List<ReadingDayEntity> readingDays; // oldest first, today last

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage = '',
    this.dailyVerse,
    this.lastLocation = const ReadingProgressEntity(
      lastBook: 'genesis',
      lastChapter: 1,
    ),
    this.chaptersCompleted = 0,
    this.chapterCount = 0,
    this.readingDays = const [],
  });

  int get remainingChapters {
    final remaining = chapterCount - chaptersCompleted;
    return remaining <= 0 ? 0 : remaining;
  }

  bool get bookCompleted =>
      chapterCount > 0 && chaptersCompleted >= chapterCount;

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    DailyVerseEntity? dailyVerse,
    ReadingProgressEntity? lastLocation,
    int? chaptersCompleted,
    int? chapterCount,
    List<ReadingDayEntity>? readingDays,
  }) => HomeState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    dailyVerse: dailyVerse ?? this.dailyVerse,
    lastLocation: lastLocation ?? this.lastLocation,
    chaptersCompleted: chaptersCompleted ?? this.chaptersCompleted,
    chapterCount: chapterCount ?? this.chapterCount,
    readingDays: readingDays ?? this.readingDays,
  );

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    dailyVerse,
    lastLocation,
    chaptersCompleted,
    chapterCount,
    readingDays,
  ];
}
