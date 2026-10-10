import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';

void main() {
  late _MockGetChapterCount getChapterCount;
  late _MockGetChapterVerses getChapterVerses;

  setUp(() {
    getChapterCount = _MockGetChapterCount();
    getChapterVerses = _MockGetChapterVerses();
    when(() => getChapterCount(any()))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses(any(), any()))
        .thenAnswer((_) async => const Right<Failure, List<VerseEntity>>([]));
  });

  PassagePickerCubit createCubit() => PassagePickerCubit(
    getChapterCount: getChapterCount,
    getChapterVerses: getChapterVerses,
  );

  blocTest<PassagePickerCubit, PassagePickerState>(
    'initializes on the current book chapter grid',
    build: createCubit,
    act: (cubit) => cubit.initialize(
      currentBook: 'genesis',
      currentChapter: 1,
      currentVerseNumber: 1,
    ),
    expect: () => [
      isA<PassagePickerState>()
          .having(
            (state) => state.status,
            'status',
            PassagePickerStatus.loading,
          )
          .having((state) => state.tab, 'tab', PassagePickerTab.currentBook)
          .having((state) => state.level, 'level', PassagePickerLevel.chapters),
      isA<PassagePickerState>()
          .having(
            (state) => state.status,
            'status',
            PassagePickerStatus.success,
          )
          .having((state) => state.chapterCount, 'chapterCount', 50),
    ],
  );

  blocTest<PassagePickerCubit, PassagePickerState>(
    'switches to the old testament book list',
    build: createCubit,
    act: (cubit) => cubit.selectTab(PassagePickerTab.oldTestament),
    expect: () => [
      isA<PassagePickerState>()
          .having((state) => state.tab, 'tab', PassagePickerTab.oldTestament)
          .having((state) => state.level, 'level', PassagePickerLevel.books),
      isA<PassagePickerState>().having(
        (state) => state.status,
        'status',
        PassagePickerStatus.success,
      ),
    ],
  );

  blocTest<PassagePickerCubit, PassagePickerState>(
    'selecting a book loads its chapter grid',
    setUp: () {
      when(() => getChapterCount('exodus'))
          .thenAnswer((_) async => const Right<Failure, int>(40));
    },
    build: createCubit,
    seed: () => const PassagePickerState(
      tab: PassagePickerTab.oldTestament,
      level: PassagePickerLevel.books,
      status: PassagePickerStatus.success,
    ),
    act: (cubit) => cubit.selectBook('exodus'),
    expect: () => [
      isA<PassagePickerState>()
          .having((state) => state.selectedBook, 'selectedBook', 'exodus')
          .having((state) => state.level, 'level', PassagePickerLevel.chapters),
      isA<PassagePickerState>()
          .having(
            (state) => state.status,
            'status',
            PassagePickerStatus.success,
          )
          .having((state) => state.chapterCount, 'chapterCount', 40),
    ],
  );

  blocTest<PassagePickerCubit, PassagePickerState>(
    'selecting a chapter loads its verse grid',
    setUp: () {
      when(() => getChapterVerses('genesis', 3)).thenAnswer(
        (_) async => Right<Failure, List<VerseEntity>>(
          List.generate(
            4,
            (index) => VerseEntity(
              book: 'genesis',
              chapter: 3,
              verse: index + 1,
              text: 'Verse',
            ),
          ),
        ),
      );
    },
    build: createCubit,
    seed: () => const PassagePickerState(
      currentBook: 'genesis',
      tab: PassagePickerTab.currentBook,
      level: PassagePickerLevel.chapters,
      chapterCount: 50,
      status: PassagePickerStatus.success,
    ),
    act: (cubit) => cubit.selectChapter(3),
    expect: () => [
      isA<PassagePickerState>()
          .having((state) => state.selectedChapter, 'selectedChapter', 3)
          .having((state) => state.level, 'level', PassagePickerLevel.verses),
      isA<PassagePickerState>()
          .having(
            (state) => state.status,
            'status',
            PassagePickerStatus.success,
          )
          .having((state) => state.verseCount, 'verseCount', 4),
    ],
  );

  blocTest<PassagePickerCubit, PassagePickerState>(
    'emits a failure when the chapter count cannot be loaded',
    setUp: () {
      when(() => getChapterCount('genesis')).thenAnswer(
        (_) async =>
            const Left<Failure, int>(DatabaseFailure('db unavailable')),
      );
    },
    build: createCubit,
    act: (cubit) => cubit.initialize(
      currentBook: 'genesis',
      currentChapter: 1,
      currentVerseNumber: 1,
    ),
    expect: () => [
      isA<PassagePickerState>().having(
        (state) => state.status,
        'status',
        PassagePickerStatus.loading,
      ),
      isA<PassagePickerState>()
          .having(
            (state) => state.status,
            'status',
            PassagePickerStatus.failure,
          )
          .having(
            (state) => state.errorMessage,
            'errorMessage',
            'db unavailable',
          ),
    ],
  );

  test(
    'goes back from verses to chapters and from chapters to books',
    () async {
      when(() => getChapterVerses('genesis', 3)).thenAnswer(
        (_) async => Right<Failure, List<VerseEntity>>(
          List.generate(
            4,
            (index) => VerseEntity(
              book: 'genesis',
              chapter: 3,
              verse: index + 1,
              text: 'Verse',
            ),
          ),
        ),
      );

      final cubit = createCubit();
      await cubit.initialize(
        currentBook: 'genesis',
        currentChapter: 1,
        currentVerseNumber: 1,
      );

      await cubit.selectTab(PassagePickerTab.oldTestament);
      await cubit.selectBook('exodus');
      await cubit.selectChapter(3);
      expect(cubit.state.level, PassagePickerLevel.verses);

      cubit.goBack();
      expect(cubit.state.level, PassagePickerLevel.chapters);
      expect(cubit.state.selectedChapter, isNull);
      expect(cubit.state.canGoBack, isTrue);

      cubit.goBack();
      expect(cubit.state.level, PassagePickerLevel.books);
      expect(cubit.state.selectedBook, isNull);
      expect(cubit.state.canGoBack, isFalse);
      await cubit.close();
    },
  );
}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockGetChapterVerses extends Mock implements GetChapterVerses {}
