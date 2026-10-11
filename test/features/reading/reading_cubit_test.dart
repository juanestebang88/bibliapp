import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_reference.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/search_focus.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

void main() {
  late _MockGetChapterVerses getChapterVerses;
  late _MockGetChapterCount getChapterCount;
  late _MockGetReadingProgress getReadingProgress;
  late _MockSaveReadingProgress saveReadingProgress;
  late _MockGetReadingSettings getReadingSettings;
  late _MockSaveReadingSettings saveReadingSettings;

  setUpAll(() {
    registerFallbackValue(const ReadingSettingsEntity());
    registerFallbackValue(
      const ReadingProgressEntity(lastBook: 'genesis', lastChapter: 1),
    );
  });

  setUp(() {
    getChapterVerses = _MockGetChapterVerses();
    getChapterCount = _MockGetChapterCount();
    getReadingProgress = _MockGetReadingProgress();
    saveReadingProgress = _MockSaveReadingProgress();
    getReadingSettings = _MockGetReadingSettings();
    saveReadingSettings = _MockSaveReadingSettings();
    when(() => getReadingSettings()).thenAnswer(
      (_) async => const Right<Failure, ReadingSettingsEntity?>(null),
    );
    when(() => saveReadingSettings(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => saveReadingProgress(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => getChapterCount(any()))
        .thenAnswer((_) async => const Right<Failure, int>(1));
    when(() => getChapterVerses(any(), any()))
        .thenAnswer((_) async => const Right<Failure, List<VerseEntity>>([]));
  });

  ReadingCubit createCubit() => ReadingCubit(
    getChapterVerses: getChapterVerses,
    getChapterCount: getChapterCount,
    getReadingProgress: getReadingProgress,
    saveReadingProgress: saveReadingProgress,
    getReadingSettings: getReadingSettings,
    saveReadingSettings: saveReadingSettings,
  );

  List<VerseEntity> versesFor(
    int count, {
    String book = 'genesis',
    int chapter = 1,
  }) => List.generate(
    count,
    (index) => VerseEntity(
      book: book,
      chapter: chapter,
      verse: index + 1,
      text: 'Verse',
    ),
  );

  blocTest<ReadingCubit, ReadingState>(
    'restores the saved chapter and opens at its first verse',
    setUp: () {
      when(() => getReadingProgress()).thenAnswer(
        (_) async => const Right<Failure, ReadingProgressEntity?>(
          ReadingProgressEntity(lastBook: 'john', lastChapter: 3),
        ),
      );
      when(() => getChapterVerses('john', 3)).thenAnswer(
        (_) async => Right<Failure, List<VerseEntity>>(
          List.generate(
            21,
            (index) => VerseEntity(
              book: 'john',
              chapter: 3,
              verse: index + 1,
              text: 'Verse',
            ),
          ),
        ),
      );
    },
    build: createCubit,
    act: (cubit) => cubit.initialize(),
    expect: () => [
      isA<ReadingState>().having(
        (state) => state.status,
        'status',
        ReadingStatus.loading,
      ),
      isA<ReadingState>()
          .having((state) => state.status, 'status', ReadingStatus.success)
          .having((state) => state.currentBook, 'book', 'john')
          .having((state) => state.currentChapter, 'chapter', 3)
          .having((state) => state.currentVerseNumber, 'verse', 1),
    ],
  );

  blocTest<ReadingCubit, ReadingState>(
    'emits a failure when chapter loading fails',
    setUp: () {
      when(() => getReadingProgress()).thenAnswer(
        (_) async => const Right<Failure, ReadingProgressEntity?>(null),
      );
      when(() => getChapterVerses('genesis', 1)).thenAnswer(
        (_) async => const Left<Failure, List<VerseEntity>>(
          DatabaseFailure('database unavailable'),
        ),
      );
    },
    build: createCubit,
    act: (cubit) => cubit.initialize(),
    expect: () => [
      isA<ReadingState>().having(
        (state) => state.status,
        'status',
        ReadingStatus.loading,
      ),
      isA<ReadingState>()
          .having((state) => state.status, 'status', ReadingStatus.failure)
          .having(
            (state) => state.errorMessage,
            'errorMessage',
            'database unavailable',
          ),
    ],
  );

  blocTest<ReadingCubit, ReadingState>(
    'restores the persisted font size on initialize',
    setUp: () {
      when(() => getReadingSettings()).thenAnswer(
        (_) async => const Right<Failure, ReadingSettingsEntity?>(
          ReadingSettingsEntity(fontSize: 24),
        ),
      );
      when(() => getReadingProgress()).thenAnswer(
        (_) async => const Right<Failure, ReadingProgressEntity?>(null),
      );
      when(() => getChapterVerses('genesis', 1)).thenAnswer(
        (_) async => const Right<Failure, List<VerseEntity>>([
          VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Verse'),
        ]),
      );
    },
    build: createCubit,
    act: (cubit) => cubit.initialize(),
    expect: () => [
      isA<ReadingState>()
          .having((state) => state.status, 'status', ReadingStatus.loading)
          .having((state) => state.fontSize, 'fontSize', 24),
      isA<ReadingState>().having(
        (state) => state.status,
        'status',
        ReadingStatus.success,
      ),
    ],
  );

  blocTest<ReadingCubit, ReadingState>(
    'adjusts the font size and persists it',
    setUp: () {
      when(() => saveReadingSettings(any()))
          .thenAnswer((_) async => const Right<Failure, bool>(true));
    },
    build: createCubit,
    act: (cubit) => cubit.adjustFontSize(1),
    expect: () => [
      isA<ReadingState>().having((state) => state.fontSize, 'fontSize', 21),
    ],
    verify: (_) {
      verify(
        () => saveReadingSettings(const ReadingSettingsEntity(fontSize: 21)),
      ).called(1);
    },
  );

  test('flags the navigation boundaries of the Bible', () {
    const genesis1 = ReadingState();
    expect(genesis1.isFirstChapter, isTrue);
    expect(genesis1.isLastChapter, isFalse);

    const revelationLast = ReadingState(
      currentBook: 'revelation',
      currentChapter: 22,
      bookChapterCount: 22,
    );
    expect(revelationLast.isFirstChapter, isFalse);
    expect(revelationLast.isLastChapter, isTrue);
  });

  test('moves to the previous chapter within the same book', () async {
    when(() => getChapterCount(any()))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('genesis', 2)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(3, book: 'genesis', chapter: 2),
      ),
    );
    when(() => getChapterVerses('genesis', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(3, book: 'genesis', chapter: 1),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapter('genesis', 2);
    await cubit.previousChapter();

    expect(cubit.state.status, ReadingStatus.success);
    expect(cubit.state.currentBook, 'genesis');
    expect(cubit.state.currentChapter, 1);
    await cubit.close();
  });
  test('wraps from the first chapter of a book to the previous book', () async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('exodus', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(2, book: 'exodus', chapter: 1),
      ),
    );
    when(() => getChapterVerses('genesis', 50)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(2, book: 'genesis', chapter: 50),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapter('exodus', 1);
    await cubit.previousChapter();

    expect(cubit.state.status, ReadingStatus.success);
    expect(cubit.state.currentBook, 'genesis');
    expect(cubit.state.currentChapter, 50);
    await cubit.close();
  });

  test('wraps from the last chapter of a book to the next book', () async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('genesis', 50)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(2, book: 'genesis', chapter: 50),
      ),
    );
    when(() => getChapterVerses('exodus', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(2, book: 'exodus', chapter: 1),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapter('genesis', 50);
    await cubit.nextChapter();

    expect(cubit.state.status, ReadingStatus.success);
    expect(cubit.state.currentBook, 'exodus');
    expect(cubit.state.currentChapter, 1);
    await cubit.close();
  });

  test(
    'does not wrap before Genesis 1 when going to the previous chapter',
    () async {
      when(() => getChapterVerses('genesis', 1)).thenAnswer(
        (_) async => Right<Failure, List<VerseEntity>>(
          versesFor(2, book: 'genesis', chapter: 1),
        ),
      );

      final cubit = createCubit();
      await cubit.loadChapter('genesis', 1);
      await cubit.previousChapter();

      expect(cubit.state.status, ReadingStatus.success);
      expect(cubit.state.currentBook, 'genesis');
      expect(cubit.state.currentChapter, 1);
      await cubit.close();
    },
  );

  test(
    'exposes previous and next chapter references within the book',
    () async {
      when(() => getChapterCount('genesis'))
          .thenAnswer((_) async => const Right<Failure, int>(50));
      when(() => getChapterVerses('genesis', 2)).thenAnswer(
        (_) async => Right<Failure, List<VerseEntity>>(
          versesFor(3, book: 'genesis', chapter: 2),
        ),
      );

      final cubit = createCubit();
      await cubit.loadChapter('genesis', 2);

      expect(
        cubit.state.previousChapterReference,
        const ChapterReference(book: 'genesis', chapter: 1),
      );
      expect(
        cubit.state.nextChapterReference,
        const ChapterReference(book: 'genesis', chapter: 3),
      );
      await cubit.close();
    },
  );

  test('resolves references across book boundaries', () async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterCount('exodus'))
        .thenAnswer((_) async => const Right<Failure, int>(40));
    when(() => getChapterVerses('exodus', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(2, book: 'exodus', chapter: 1),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapter('exodus', 1);

    expect(
      cubit.state.previousChapterReference,
      const ChapterReference(book: 'genesis', chapter: 50),
    );
    expect(
      cubit.state.nextChapterReference,
      const ChapterReference(book: 'exodus', chapter: 2),
    );
    await cubit.close();
  });

  test('has no previous reference at the start of the Bible', () async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('genesis', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(3, book: 'genesis', chapter: 1),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapter('genesis', 1);

    expect(cubit.state.previousChapterReference, isNull);
    expect(
      cubit.state.nextChapterReference,
      const ChapterReference(book: 'genesis', chapter: 2),
    );
    await cubit.close();
  });

  test('clears the previous reference when returning to Genesis 1', () async {
    when(() => getChapterCount(any()))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('exodus', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(2, book: 'exodus', chapter: 1),
      ),
    );
    when(() => getChapterVerses('genesis', 1)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(2, book: 'genesis', chapter: 1),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapter('exodus', 1);
    expect(cubit.state.previousChapterReference, isNotNull);

    await cubit.loadChapter('genesis', 1);
    expect(cubit.state.previousChapterReference, isNull);
    await cubit.close();
  });

  test('loads a chapter and marks the target verse for scroll', () async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('genesis', 3)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(5, book: 'genesis', chapter: 3),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapterAndScrollTo('genesis', 3, 5);

    expect(cubit.state.status, ReadingStatus.success);
    expect(cubit.state.currentBook, 'genesis');
    expect(cubit.state.currentChapter, 3);
    expect(cubit.state.currentVerseNumber, 5);
    expect(cubit.state.pendingScrollVerse, 5);

    cubit.consumePendingScroll();
    expect(cubit.state.pendingScrollVerse, isNull);
    await cubit.close();
  });

  test(
    'keeps active focus on the jump chapter and clears it when it changes',
    () async {
      when(() => getChapterCount('genesis'))
          .thenAnswer((_) async => const Right<Failure, int>(50));
      when(() => getChapterVerses('genesis', 3)).thenAnswer(
        (_) async => Right<Failure, List<VerseEntity>>(
          versesFor(5, book: 'genesis', chapter: 3),
        ),
      );
      when(() => getChapterVerses('genesis', 4)).thenAnswer(
        (_) async => Right<Failure, List<VerseEntity>>(
          versesFor(5, book: 'genesis', chapter: 4),
        ),
      );

      final cubit = createCubit();
      await cubit.loadChapterAndScrollTo('genesis', 3, 5);
      expect(
        cubit.state.activeFocus,
        const SearchFocus(book: 'genesis', chapter: 3, verse: 5),
      );

      await cubit.loadChapter('genesis', 3);
      expect(cubit.state.activeFocus, isNotNull);

      await cubit.loadChapter('genesis', 4);
      expect(cubit.state.activeFocus, isNull);
      await cubit.close();
    },
  );

  test('clearFocus drops the active search focus', () async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('genesis', 3)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        versesFor(5, book: 'genesis', chapter: 3),
      ),
    );

    final cubit = createCubit();
    await cubit.loadChapterAndScrollTo('genesis', 3, 5);
    expect(cubit.state.activeFocus, isNotNull);

    cubit.clearFocus();
    expect(cubit.state.activeFocus, isNull);
    await cubit.close();
  });
}

class _MockGetChapterVerses extends Mock implements GetChapterVerses {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockGetReadingProgress extends Mock implements GetReadingProgress {}

class _MockSaveReadingProgress extends Mock implements SaveReadingProgress {}

class _MockGetReadingSettings extends Mock implements GetReadingSettings {}

class _MockSaveReadingSettings extends Mock implements SaveReadingSettings {}
