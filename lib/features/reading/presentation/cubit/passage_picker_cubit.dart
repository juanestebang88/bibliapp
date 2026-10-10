import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';

enum PassagePickerTab { currentBook, oldTestament, newTestament }

enum PassagePickerLevel { chapters, books, verses }

enum PassagePickerStatus { initial, loading, success, failure }

class PassagePickerState extends Equatable {
  final PassagePickerTab tab;
  final PassagePickerLevel level;
  final String currentBook;
  final int currentChapter;
  final int currentVerseNumber;
  final String? selectedBook;
  final int? selectedChapter;
  final int chapterCount;
  final int verseCount;
  final PassagePickerStatus status;
  final String? errorMessage;

  const PassagePickerState({
    this.tab = PassagePickerTab.currentBook,
    this.level = PassagePickerLevel.chapters,
    this.currentBook = 'genesis',
    this.currentChapter = 1,
    this.currentVerseNumber = 1,
    this.selectedBook,
    this.selectedChapter,
    this.chapterCount = 0,
    this.verseCount = 0,
    this.status = PassagePickerStatus.initial,
    this.errorMessage,
  });

  bool get canGoBack {
    if (level == PassagePickerLevel.verses) return true;
    return level == PassagePickerLevel.chapters &&
        tab != PassagePickerTab.currentBook &&
        selectedBook != null;
  }

  PassagePickerState copyWith({
    PassagePickerTab? tab,
    PassagePickerLevel? level,
    String? currentBook,
    int? currentChapter,
    int? currentVerseNumber,
    String? selectedBook,
    int? selectedChapter,
    int? chapterCount,
    int? verseCount,
    PassagePickerStatus? status,
    String? errorMessage,
    bool clearSelectedBook = false,
    bool clearSelectedChapter = false,
    bool clearErrorMessage = false,
  }) => PassagePickerState(
    tab: tab ?? this.tab,
    level: level ?? this.level,
    currentBook: currentBook ?? this.currentBook,
    currentChapter: currentChapter ?? this.currentChapter,
    currentVerseNumber: currentVerseNumber ?? this.currentVerseNumber,
    selectedBook: clearSelectedBook ? null : selectedBook ?? this.selectedBook,
    selectedChapter: clearSelectedChapter
        ? null
        : selectedChapter ?? this.selectedChapter,
    chapterCount: chapterCount ?? this.chapterCount,
    verseCount: verseCount ?? this.verseCount,
    status: status ?? this.status,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    tab,
    level,
    currentBook,
    currentChapter,
    currentVerseNumber,
    selectedBook,
    selectedChapter,
    chapterCount,
    verseCount,
    status,
    errorMessage,
  ];
}

class PassagePickerCubit extends Cubit<PassagePickerState> {
  final GetChapterCount getChapterCount;
  final GetChapterVerses getChapterVerses;

  PassagePickerCubit({
    required this.getChapterCount,
    required this.getChapterVerses,
  }) : super(const PassagePickerState());

  Future<void> initialize({
    required String currentBook,
    required int currentChapter,
    required int currentVerseNumber,
  }) async {
    emit(
      state.copyWith(
        currentBook: currentBook,
        currentChapter: currentChapter,
        currentVerseNumber: currentVerseNumber,
        tab: PassagePickerTab.currentBook,
        level: PassagePickerLevel.chapters,
        status: PassagePickerStatus.loading,
        clearSelectedBook: true,
        clearSelectedChapter: true,
        clearErrorMessage: true,
      ),
    );
    await _loadChapterCount(currentBook);
  }

  Future<void> selectTab(PassagePickerTab tab) async {
    if (tab == state.tab) return;
    emit(
      state.copyWith(
        tab: tab,
        level: tab == PassagePickerTab.currentBook
            ? PassagePickerLevel.chapters
            : PassagePickerLevel.books,
        status: PassagePickerStatus.loading,
        clearSelectedBook: true,
        clearSelectedChapter: true,
        clearErrorMessage: true,
      ),
    );
    if (tab == PassagePickerTab.currentBook) {
      await _loadChapterCount(state.currentBook);
    } else {
      emit(state.copyWith(status: PassagePickerStatus.success));
    }
  }

  Future<void> selectBook(String book) async {
    emit(
      state.copyWith(
        selectedBook: book,
        level: PassagePickerLevel.chapters,
        status: PassagePickerStatus.loading,
        clearSelectedChapter: true,
        clearErrorMessage: true,
      ),
    );
    await _loadChapterCount(book);
  }

  Future<void> selectChapter(int chapter) async {
    final book = state.selectedBook ?? state.currentBook;
    emit(
      state.copyWith(
        selectedChapter: chapter,
        level: PassagePickerLevel.verses,
        status: PassagePickerStatus.loading,
        clearErrorMessage: true,
      ),
    );
    await _loadVerseCount(book, chapter);
  }

  void goBack() {
    switch (state.level) {
      case PassagePickerLevel.verses:
        emit(
          state.copyWith(
            level: PassagePickerLevel.chapters,
            status: PassagePickerStatus.success,
            clearSelectedChapter: true,
            clearErrorMessage: true,
          ),
        );
      case PassagePickerLevel.chapters:
        if (state.tab != PassagePickerTab.currentBook) {
          emit(
            state.copyWith(
              level: PassagePickerLevel.books,
              status: PassagePickerStatus.success,
              clearSelectedBook: true,
              clearErrorMessage: true,
            ),
          );
        }
      case PassagePickerLevel.books:
        break;
    }
  }

  Future<void> _loadChapterCount(String book) async {
    final result = await getChapterCount(book);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: PassagePickerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (count) => emit(
        state.copyWith(
          chapterCount: count,
          status: PassagePickerStatus.success,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  Future<void> _loadVerseCount(String book, int chapter) async {
    final result = await getChapterVerses(book, chapter);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: PassagePickerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (verses) => emit(
        state.copyWith(
          verseCount: verses.length,
          status: PassagePickerStatus.success,
          clearErrorMessage: true,
        ),
      ),
    );
  }
}
