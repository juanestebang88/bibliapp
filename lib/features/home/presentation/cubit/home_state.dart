import 'package:equatable/equatable.dart';
import 'package:bibliapp/features/reading/domain/entities/continue_reading_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String errorMessage; // UI-ready message
  final DailyVerseEntity? dailyVerse;

  /// Where the user should continue reading (null = nothing marked yet).
  final ContinueReadingEntity? continueLocation;

  /// The book the continue location points at (or 'genesis' by default).
  final String continueBook;

  final int chaptersCompleted; // of continueBook
  final int chapterCount; // of continueBook
  final List<ReadingDayEntity> readingDays; // oldest first, today last

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage = '',
    this.dailyVerse,
    this.continueLocation,
    this.continueBook = 'genesis',
    this.chaptersCompleted = 0,
    this.chapterCount = 0,
    this.readingDays = const [],
  });

  int get continueChapter => continueLocation?.chapter ?? 1;

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
    ContinueReadingEntity? continueLocation,
    String? continueBook,
    int? chaptersCompleted,
    int? chapterCount,
    List<ReadingDayEntity>? readingDays,
    bool clearContinueLocation = false,
  }) => HomeState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    dailyVerse: dailyVerse ?? this.dailyVerse,
    continueLocation: clearContinueLocation
        ? null
        : continueLocation ?? this.continueLocation,
    continueBook: continueBook ?? this.continueBook,
    chaptersCompleted: chaptersCompleted ?? this.chaptersCompleted,
    chapterCount: chapterCount ?? this.chapterCount,
    readingDays: readingDays ?? this.readingDays,
  );

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    dailyVerse,
    continueLocation,
    continueBook,
    chaptersCompleted,
    chapterCount,
    readingDays,
  ];
}
