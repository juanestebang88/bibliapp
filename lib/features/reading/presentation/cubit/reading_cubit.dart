import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/features/reading/domain/book_order.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_reference.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';

enum ReadingStatus { initial, loading, success, failure }

class ReadingState extends Equatable {
  final ReadingStatus status;
  final List<VerseEntity> chapterVerses;
  final double fontSize;
  final String currentBook;
  final int currentChapter;
  final int currentVerseNumber;
  final int? bookChapterCount;
  final ChapterReference? previousChapterReference;
  final ChapterReference? nextChapterReference;
  final ReadingProgressEntity? savedProgress;
  final String? errorMessage;
  final List<VerseEntity> previousChapterVerses;
  final List<VerseEntity> nextChapterVerses;

  const ReadingState({
    this.status = ReadingStatus.initial,
    this.chapterVerses = const [],
    this.fontSize = 20,
    this.currentBook = 'genesis',
    this.currentChapter = 1,
    this.currentVerseNumber = 1,
    this.bookChapterCount,
    this.previousChapterReference,
    this.nextChapterReference,
    this.savedProgress,
    this.errorMessage,
    this.previousChapterVerses = const [],
    this.nextChapterVerses = const [],
  });

  bool get isFirstChapter => currentBook == 'genesis' && currentChapter == 1;

  bool get isLastChapter =>
      currentBook == 'revelation' && currentChapter == (bookChapterCount ?? 1);

  ReadingState copyWith({
    ReadingStatus? status,
    List<VerseEntity>? chapterVerses,
    double? fontSize,
    String? currentBook,
    int? currentChapter,
    int? currentVerseNumber,
    int? bookChapterCount,
    ChapterReference? previousChapterReference,
    ChapterReference? nextChapterReference,
    ReadingProgressEntity? savedProgress,
    String? errorMessage,
    List<VerseEntity>? previousChapterVerses,
    List<VerseEntity>? nextChapterVerses,
    bool clearErrorMessage = false,
    bool clearPreviousChapterReference = false,
    bool clearNextChapterReference = false,
    bool clearPreviousChapterVerses = false,
    bool clearNextChapterVerses = false,
  }) => ReadingState(
    status: status ?? this.status,
    chapterVerses: chapterVerses ?? this.chapterVerses,
    fontSize: fontSize ?? this.fontSize,
    currentBook: currentBook ?? this.currentBook,
    currentChapter: currentChapter ?? this.currentChapter,
    currentVerseNumber: currentVerseNumber ?? this.currentVerseNumber,
    bookChapterCount: bookChapterCount ?? this.bookChapterCount,
    previousChapterReference: clearPreviousChapterReference
        ? null
        : previousChapterReference ?? this.previousChapterReference,
    nextChapterReference: clearNextChapterReference
        ? null
        : nextChapterReference ?? this.nextChapterReference,
    savedProgress: savedProgress ?? this.savedProgress,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    previousChapterVerses: clearPreviousChapterVerses
        ? const []
        : previousChapterVerses ?? this.previousChapterVerses,
    nextChapterVerses: clearNextChapterVerses
        ? const []
        : nextChapterVerses ?? this.nextChapterVerses,
  );

  @override
  List<Object?> get props => [
    status,
    chapterVerses,
    fontSize,
    currentBook,
    currentChapter,
    currentVerseNumber,
    bookChapterCount,
    previousChapterReference,
    nextChapterReference,
    savedProgress,
    errorMessage,
    previousChapterVerses,
    nextChapterVerses,
  ];
}

class ReadingCubit extends Cubit<ReadingState> {
  final GetChapterVerses getChapterVerses;
  final GetChapterCount getChapterCount;
  final GetReadingProgress getReadingProgress;
  final SaveReadingProgress saveReadingProgress;
  final GetReadingSettings getReadingSettings;
  final SaveReadingSettings saveReadingSettings;

  ReadingCubit({
    required this.getChapterVerses,
    required this.getChapterCount,
    required this.getReadingProgress,
    required this.saveReadingProgress,
    required this.getReadingSettings,
    required this.saveReadingSettings,
  }) : super(const ReadingState());

  Future<void> initialize() async {
    final settings = await getReadingSettings();
    final fontSize =
        settings.getOrElse((_) => null)?.fontSize ?? state.fontSize.round();
    emit(
      state.copyWith(
        status: ReadingStatus.loading,
        fontSize: fontSize.toDouble(),
        clearErrorMessage: true,
      ),
    );
    final result = await getReadingProgress();
    await result.match(
      (failure) async {
        emit(
          state.copyWith(
            status: ReadingStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (progress) => loadChapter(
        progress?.lastBook ?? 'genesis',
        progress?.lastChapter ?? 1,
        verse: progress?.lastVerse ?? 1,
        saveProgress: false,
      ),
    );
  }

  Future<void> loadChapter(
    String book,
    int chapter, {
    int verse = 1,
    bool saveProgress = true,
  }) async {
    if (chapter < 1) return;

    final previousRef = state.previousChapterReference;
    if (previousRef?.book == book &&
        previousRef?.chapter == chapter &&
        state.previousChapterVerses.isNotEmpty) {
      await _completeChapterLoad(
        book,
        chapter,
        state.previousChapterVerses,
        verse: verse,
        saveProgress: saveProgress,
      );
      return;
    }

    final nextRef = state.nextChapterReference;
    if (nextRef?.book == book &&
        nextRef?.chapter == chapter &&
        state.nextChapterVerses.isNotEmpty) {
      await _completeChapterLoad(
        book,
        chapter,
        state.nextChapterVerses,
        verse: verse,
        saveProgress: saveProgress,
      );
      return;
    }

    emit(
      state.copyWith(status: ReadingStatus.loading, clearErrorMessage: true),
    );

    final result = await getChapterVerses(book, chapter);
    if (result.isLeft()) {
      final failureMessage =
          result.getLeft().toNullable()?.message ??
          'Failed to load the chapter';
      emit(
        state.copyWith(
          status: ReadingStatus.failure,
          errorMessage: failureMessage,
        ),
      );
      return;
    }

    final verses = result.getOrElse((_) => const <VerseEntity>[]);

    if (verses.isEmpty) {
      emit(state.copyWith(status: ReadingStatus.success));
      return;
    }

    await _completeChapterLoad(
      book,
      chapter,
      verses,
      verse: verse,
      saveProgress: saveProgress,
    );
  }

  Future<void> _completeChapterLoad(
    String book,
    int chapter,
    List<VerseEntity> verses, {
    int verse = 1,
    bool saveProgress = true,
  }) async {
    final chapterCount = (await getChapterCount(book)).getOrElse((_) => 1);

    final previousChapterReference = await _resolvePreviousReference(
      book,
      chapter,
    );
    final nextChapterReference = _resolveNextReference(
      book,
      chapter,
      chapterCount,
    );

    final previousChapterVerses = await _fetchVersesOf(
      previousChapterReference,
    );
    final nextChapterVerses = await _fetchVersesOf(nextChapterReference);

    emit(
      state.copyWith(
        status: ReadingStatus.success,
        chapterVerses: verses,
        currentBook: book,
        currentChapter: chapter,
        currentVerseNumber: verse.clamp(1, verses.length),
        bookChapterCount: chapterCount,
        previousChapterReference: previousChapterReference,
        clearPreviousChapterReference: previousChapterReference == null,
        nextChapterReference: nextChapterReference,
        clearNextChapterReference: nextChapterReference == null,
        previousChapterVerses: previousChapterVerses,
        clearPreviousChapterVerses: previousChapterReference == null,
        nextChapterVerses: nextChapterVerses,
        clearNextChapterVerses: nextChapterReference == null,
        clearErrorMessage: true,
      ),
    );
    if (saveProgress) await saveCurrentProgress();
  }

  Future<List<VerseEntity>> _fetchVersesOf(ChapterReference? reference) async {
    if (reference == null) return const [];
    return (await getChapterVerses(
      reference.book,
      reference.chapter,
    )).getOrElse((_) => const <VerseEntity>[]);
  }

  Future<ChapterReference?> _resolvePreviousReference(
    String book,
    int chapter,
  ) async {
    if (chapter > 1) {
      return ChapterReference(book: book, chapter: chapter - 1);
    }
    final bookIndex = bibleBookOrder.indexOf(book);
    if (bookIndex <= 0) return null;
    final previousBook = bibleBookOrder[bookIndex - 1];
    final chapterCount = (await getChapterCount(previousBook))
        .getOrElse((_) => 1);
    return ChapterReference(
      book: previousBook,
      chapter: chapterCount <= 0 ? 1 : chapterCount,
    );
  }

  ChapterReference? _resolveNextReference(
    String book,
    int chapter,
    int chapterCount,
  ) {
    if (chapter < chapterCount) {
      return ChapterReference(book: book, chapter: chapter + 1);
    }
    final bookIndex = bibleBookOrder.indexOf(book);
    if (bookIndex >= 0 && bookIndex < bibleBookOrder.length - 1) {
      return ChapterReference(book: bibleBookOrder[bookIndex + 1], chapter: 1);
    }
    return null;
  }

  Future<void> adjustFontSize(double delta) async {
    final newSize = (state.fontSize + delta).clamp(14.0, 32.0).toDouble();
    emit(state.copyWith(fontSize: newSize));
    await saveReadingSettings(ReadingSettingsEntity(fontSize: newSize.round()));
  }

  Future<void> selectVerse(int verse) async {
    if (verse < 1 || verse > state.chapterVerses.length) return;
    emit(state.copyWith(currentVerseNumber: verse));
    await saveCurrentProgress();
  }

  Future<void> previousChapter() async {
    if (state.isFirstChapter) return;
    final bookIndex = bibleBookOrder.indexOf(state.currentBook);

    if (state.currentChapter > 1) {
      await loadChapter(state.currentBook, state.currentChapter - 1);
      return;
    }

    if (bookIndex > 0) {
      final previousBook = bibleBookOrder[bookIndex - 1];
      final chapterCount = (await getChapterCount(previousBook))
          .getOrElse((_) => 1);
      await loadChapter(previousBook, chapterCount == 0 ? 1 : chapterCount);
    }
  }

  Future<void> nextChapter() async {
    if (state.isLastChapter) return;
    final bookIndex = bibleBookOrder.indexOf(state.currentBook);

    if (state.currentChapter < (state.bookChapterCount ?? 1)) {
      await loadChapter(state.currentBook, state.currentChapter + 1);
      return;
    }

    if (bookIndex >= 0 && bookIndex < bibleBookOrder.length - 1) {
      await loadChapter(bibleBookOrder[bookIndex + 1], 1);
    }
  }

  Future<void> saveCurrentProgress() async {
    final progress = ReadingProgressEntity(
      lastBook: state.currentBook,
      lastChapter: state.currentChapter,
      lastVerse: state.currentVerseNumber,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    final result = await saveReadingProgress(progress);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: ReadingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(savedProgress: progress)),
    );
  }
}
