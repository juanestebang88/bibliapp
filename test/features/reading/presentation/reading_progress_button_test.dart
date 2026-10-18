import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/add_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/check_internet_connectivity.dart';
import 'package:bibliapp/features/reading/domain/usecases/delete_verse_highlight.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_highlights.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/record_daily_reading_event.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_chapter_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/update_verse_highlight.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_progress_button.dart';

void main() {
  late _MockGetChapterVerses getChapterVerses;
  late _MockGetChapterCount getChapterCount;
  late _MockGetReadingProgress getReadingProgress;
  late _MockSaveReadingProgress saveReadingProgress;
  late _MockGetReadingSettings getReadingSettings;
  late _MockSaveReadingSettings saveReadingSettings;
  late _MockGetChapterProgress getChapterProgress;
  late _MockSaveChapterProgress saveChapterProgress;
  late _MockGetChapterHighlights getChapterHighlights;
  late _MockAddVerseHighlight addVerseHighlight;
  late _MockUpdateVerseHighlight updateVerseHighlight;
  late _MockDeleteVerseHighlight deleteVerseHighlight;
  late _MockRecordDailyReadingEvent recordDailyReadingEvent;
  late _MockCheckInternetConnectivity checkInternetConnectivity;
  late ValueNotifier<int> visibleVerse;

  setUpAll(() {
    registerFallbackValue(const ReadingSettingsEntity());
    registerFallbackValue(
      const ReadingProgressEntity(lastBook: 'genesis', lastChapter: 1),
    );
    registerFallbackValue(
      const ChapterProgressEntity(
        book: 'genesis',
        chapter: 1,
        lastVerseRead: 0,
        isComplete: false,
      ),
    );
    registerFallbackValue(
      VerseHighlightEntity(
        book: 'genesis',
        chapter: 1,
        verse: 1,
        startOffset: 0,
        endOffset: 1,
        color: HighlightColor.yellow,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    getChapterVerses = _MockGetChapterVerses();
    getChapterCount = _MockGetChapterCount();
    getReadingProgress = _MockGetReadingProgress();
    saveReadingProgress = _MockSaveReadingProgress();
    getReadingSettings = _MockGetReadingSettings();
    saveReadingSettings = _MockSaveReadingSettings();
    getChapterProgress = _MockGetChapterProgress();
    saveChapterProgress = _MockSaveChapterProgress();
    getChapterHighlights = _MockGetChapterHighlights();
    addVerseHighlight = _MockAddVerseHighlight();
    updateVerseHighlight = _MockUpdateVerseHighlight();
    deleteVerseHighlight = _MockDeleteVerseHighlight();
    recordDailyReadingEvent = _MockRecordDailyReadingEvent();
    checkInternetConnectivity = _MockCheckInternetConnectivity();
    visibleVerse = ValueNotifier<int>(1);
    when(() => saveReadingSettings(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => recordDailyReadingEvent(any(), any(), any(), any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => saveReadingProgress(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => getChapterCount(any()))
        .thenAnswer((_) async => const Right<Failure, int>(1));
    when(() => getChapterVerses(any(), any()))
        .thenAnswer((_) async => const Right<Failure, List<VerseEntity>>([]));
    when(() => getChapterProgress(any(), any())).thenAnswer(
      (_) async => const Right<Failure, ChapterProgressEntity?>(null),
    );
    when(() => saveChapterProgress(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => getChapterHighlights(any(), any())).thenAnswer(
      (_) async => const Right<Failure, List<VerseHighlightEntity>>([]),
    );
  });

  ReadingCubit createCubit() => ReadingCubit(
    getChapterVerses: getChapterVerses,
    getChapterCount: getChapterCount,
    getReadingProgress: getReadingProgress,
    saveReadingProgress: saveReadingProgress,
    getReadingSettings: getReadingSettings,
    saveReadingSettings: saveReadingSettings,
    getChapterProgress: getChapterProgress,
    saveChapterProgress: saveChapterProgress,
    getChapterHighlights: getChapterHighlights,
    addVerseHighlight: addVerseHighlight,
    updateVerseHighlight: updateVerseHighlight,
    deleteVerseHighlight: deleteVerseHighlight,
    recordDailyReadingEvent: recordDailyReadingEvent,
    checkInternetConnectivity: checkInternetConnectivity,
  );

  Future<ReadingCubit> loadChapter(WidgetTester tester) async {
    when(() => getChapterVerses('genesis', 1)).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Uno'),
        VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'Dos'),
        VerseEntity(book: 'genesis', chapter: 1, verse: 3, text: 'Tres'),
        VerseEntity(book: 'genesis', chapter: 1, verse: 4, text: 'Cuatro'),
      ]),
    );
    final cubit = createCubit();
    await cubit.loadChapter('genesis', 1);
    return cubit;
  }

  Future<void> pumpButton(WidgetTester tester, ReadingCubit cubit) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: BlocBuilder<ReadingCubit, ReadingState>(
              builder: (context, state) => Center(
                child: ReadingProgressButton(
                  state: state,
                  visibleVerse: visibleVerse,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  tearDown(() {
    visibleVerse.dispose();
  });

  testWidgets('shows the percentage of the last visible verse over the total', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    await pumpButton(tester, cubit);
    visibleVerse.value = 2;
    await tester.pump();

    expect(find.text(AppStrings.percent(50)), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    await cubit.close();
  });

  testWidgets('shows 0 % with an empty ring and no check before any scroll', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    visibleVerse.value = 0;
    await pumpButton(tester, cubit);

    expect(find.text(AppStrings.percent(0)), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    final ring = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(ring.value, 0);
    await cubit.close();
  });

  testWidgets('tap at 0 % opens the dialog with the selector at verse 1', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    visibleVerse.value = 0;
    await pumpButton(tester, cubit);

    await tester.tap(find.byType(ReadingProgressButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.saveUpToVerse(1)), findsOneWidget);
    await cubit.close();
  });

  testWidgets('places the check below the 100 % text at the end', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    await pumpButton(tester, cubit);
    visibleVerse.value = 4;
    await tester.pump();

    final textRect = tester.getRect(find.text(AppStrings.percent(100)));
    final iconRect = tester.getRect(find.byIcon(Icons.check_circle));
    expect(iconRect.center.dy, greaterThan(textRect.center.dy));
    await cubit.close();
  });

  testWidgets('shows a white call-to-action chip at 100 % before saving', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    await pumpButton(tester, cubit);

    expect(find.text(AppStrings.tapToSaveReading), findsNothing);

    visibleVerse.value = 4;
    await tester.pump();

    expect(find.text(AppStrings.tapToSaveReading), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);

    await tester.tap(find.byKey(ReadingProgressButton.circleKey));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.tapToSaveReading), findsNothing);
    expect(find.text(AppStrings.chapterMarkedComplete), findsOneWidget);
    await cubit.close();
  });

  testWidgets(
    'shows 100 % with a check when the last verse is visible and a tap marks '
    'the chapter complete immediately',
    (tester) async {
      final cubit = await loadChapter(tester);
      await pumpButton(tester, cubit);
      visibleVerse.value = 4;
      await tester.pump();

      expect(find.text(AppStrings.percent(100)), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      await tester.tap(find.byKey(ReadingProgressButton.circleKey));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.upToWhichVerse), findsNothing);
      verify(
        () => saveChapterProgress(
          any(
            that: isA<ChapterProgressEntity>()
                .having((progress) => progress.isComplete, 'complete', true)
                .having(
                  (progress) => progress.lastVerseRead,
                  'lastVerseRead',
                  4,
                ),
          ),
        ),
      ).called(1);
      await cubit.close();
    },
  );

  testWidgets(
    'tap below 100 opens the dialog and saving up to a verse persists it',
    (tester) async {
      final cubit = await loadChapter(tester);
      await pumpButton(tester, cubit);
      visibleVerse.value = 2;
      await tester.pump();

      await tester.tap(find.byType(ReadingProgressButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.upToWhichVerse), findsOneWidget);
      expect(find.text(AppStrings.markChapterComplete), findsOneWidget);
      expect(find.text(AppStrings.saveUpToVerse(2)), findsOneWidget);

      await tester.tap(find.text(AppStrings.saveUpToVerse(2)));
      await tester.pumpAndSettle();

      verify(
        () => saveChapterProgress(
          any(
            that: isA<ChapterProgressEntity>()
                .having((progress) => progress.isComplete, 'complete', false)
                .having(
                  (progress) => progress.lastVerseRead,
                  'lastVerseRead',
                  2,
                ),
          ),
        ),
      ).called(1);
      expect(find.text(AppStrings.upToWhichVerse), findsNothing);
      await cubit.close();
    },
  );

  testWidgets(
    'a saved complete chapter shows the read state and lets the user unmark it',
    (tester) async {
      final cubit = await loadChapter(tester);
      await cubit.markChapterComplete();
      await pumpButton(tester, cubit);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text(AppStrings.percent(100)), findsNothing);

      await tester.tap(find.byType(ReadingProgressButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.unmarkChapter), findsOneWidget);
      expect(find.text(AppStrings.markChapterComplete), findsNothing);

      await tester.tap(find.text(AppStrings.unmarkChapter));
      await tester.pumpAndSettle();

      verify(
        () => saveChapterProgress(
          any(
            that: isA<ChapterProgressEntity>()
                .having((progress) => progress.isComplete, 'complete', false)
                .having(
                  (progress) => progress.lastVerseRead,
                  'lastVerseRead',
                  0,
                ),
          ),
        ),
      ).called(1);
      await cubit.close();
    },
  );

  testWidgets('defaults the selector to the last visible verse', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    await pumpButton(tester, cubit);
    visibleVerse.value = 3;
    await tester.pump();

    await tester.tap(find.byType(ReadingProgressButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.saveUpToVerse(3)), findsOneWidget);
    await cubit.close();
  });

  testWidgets('the ring interpolates from bronze to green as progress rises', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    await pumpButton(tester, cubit);
    final bronze = appTheme().colorScheme.secondary;

    Color? ringColor() => tester
        .widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        )
        .color;

    visibleVerse.value = 2;
    await tester.pump();
    expect(ringColor(), Color.lerp(bronze, AppColors.greenAccent, 0.5));

    visibleVerse.value = 4;
    await tester.pump();
    expect(ringColor(), AppColors.greenAccent);
    await cubit.close();
  });

  testWidgets('breathes once the last verse is reached and stops when read', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    await pumpButton(tester, cubit);

    visibleVerse.value = 4;
    await tester.pump();
    final scaleFinder = find.byKey(ReadingProgressButton.breathScaleKey);
    final first = tester.widget<ScaleTransition>(scaleFinder).scale.value;
    await tester.pump(const Duration(milliseconds: 300));
    final second = tester.widget<ScaleTransition>(scaleFinder).scale.value;
    expect(second, isNot(equals(first)));

    await cubit.markChapterComplete();
    await tester.pump();
    expect(scaleFinder, findsNothing);
    await cubit.close();
  });

  testWidgets('shows a confirmation pill after marking the chapter as read', (
    tester,
  ) async {
    final cubit = await loadChapter(tester);
    await pumpButton(tester, cubit);
    visibleVerse.value = 4;
    await tester.pump();

    expect(find.text(AppStrings.chapterMarkedComplete), findsNothing);

    await tester.tap(find.byKey(ReadingProgressButton.circleKey));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.chapterMarkedComplete), findsOneWidget);
    await cubit.close();
  });
}

class _MockGetChapterVerses extends Mock implements GetChapterVerses {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockGetReadingProgress extends Mock implements GetReadingProgress {}

class _MockSaveReadingProgress extends Mock implements SaveReadingProgress {}

class _MockGetReadingSettings extends Mock implements GetReadingSettings {}

class _MockSaveReadingSettings extends Mock implements SaveReadingSettings {}

class _MockGetChapterProgress extends Mock implements GetChapterProgress {}

class _MockSaveChapterProgress extends Mock implements SaveChapterProgress {}

class _MockGetChapterHighlights extends Mock implements GetChapterHighlights {}

class _MockAddVerseHighlight extends Mock implements AddVerseHighlight {}

class _MockUpdateVerseHighlight extends Mock implements UpdateVerseHighlight {}

class _MockDeleteVerseHighlight extends Mock implements DeleteVerseHighlight {}

class _MockRecordDailyReadingEvent extends Mock
    implements RecordDailyReadingEvent {}

class _MockCheckInternetConnectivity extends Mock
    implements CheckInternetConnectivity {}
