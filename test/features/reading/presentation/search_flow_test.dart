import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/router/go_router.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/add_verse_highlight.dart';
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
import 'package:bibliapp/features/reading/domain/usecases/search_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/update_verse_highlight.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/search_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/book_chip_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_navigation.dart';
import 'package:bibliapp/features/reading/presentation/widgets/consultation_continue_button.dart';
import 'package:bibliapp/features/reading/presentation/widgets/number_chip_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_header.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_focus_actions.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_progress_button.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';
import 'package:bibliapp/main.dart';

void main() {
  late _MockGetChapterVerses getChapterVerses;
  late _MockGetChapterCount getChapterCount;
  late _MockGetReadingProgress getReadingProgress;
  late _MockSaveReadingProgress saveReadingProgress;
  late _MockGetReadingSettings getReadingSettings;
  late _MockSaveReadingSettings saveReadingSettings;
  late _MockSearchVerses searchVerses;
  late _MockGetChapterProgress getChapterProgress;
  late _MockSaveChapterProgress saveChapterProgress;
  late _MockGetChapterHighlights getChapterHighlights;
  late _MockAddVerseHighlight addVerseHighlight;
  late _MockUpdateVerseHighlight updateVerseHighlight;
  late _MockDeleteVerseHighlight deleteVerseHighlight;
  late _MockRecordDailyReadingEvent recordDailyReadingEvent;

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

  setUp(() async {
    await getIt.reset();
    getChapterVerses = _MockGetChapterVerses();
    getChapterCount = _MockGetChapterCount();
    getReadingProgress = _MockGetReadingProgress();
    saveReadingProgress = _MockSaveReadingProgress();
    getReadingSettings = _MockGetReadingSettings();
    saveReadingSettings = _MockSaveReadingSettings();
    searchVerses = _MockSearchVerses();
    getChapterProgress = _MockGetChapterProgress();
    saveChapterProgress = _MockSaveChapterProgress();
    getChapterHighlights = _MockGetChapterHighlights();
    addVerseHighlight = _MockAddVerseHighlight();
    updateVerseHighlight = _MockUpdateVerseHighlight();
    deleteVerseHighlight = _MockDeleteVerseHighlight();
    recordDailyReadingEvent = _MockRecordDailyReadingEvent();
    when(() => getReadingProgress()).thenAnswer(
      (_) async => const Right<Failure, ReadingProgressEntity?>(null),
    );
    when(() => getReadingSettings()).thenAnswer(
      (_) async => const Right<Failure, ReadingSettingsEntity?>(null),
    );
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
    when(() => getChapterVerses('genesis', 1)).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(
          book: 'genesis',
          chapter: 1,
          verse: 1,
          text: 'Test verse text',
        ),
      ]),
    );
    when(() => searchVerses.call('test')).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(
          book: 'genesis',
          chapter: 1,
          verse: 1,
          text: 'Test verse text',
        ),
      ]),
    );
    when(() => getChapterProgress(any(), any())).thenAnswer(
      (_) async => const Right<Failure, ChapterProgressEntity?>(null),
    );
    when(() => saveChapterProgress(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => getChapterHighlights(any(), any())).thenAnswer(
      (_) async => const Right<Failure, List<VerseHighlightEntity>>([]),
    );
    getIt.registerFactory(
      () => ReadingCubit(
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
      ),
    );
    getIt.registerFactory(() => SearchCubit(searchVerses: searchVerses));
    getIt.registerFactory(
      () => PassagePickerCubit(
        getChapterCount: getChapterCount,
        getChapterVerses: getChapterVerses,
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpReadingApp(WidgetTester tester) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  Future<void> jumpToFirstResult(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'test');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, AppStrings.search));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Génesis 1:1'));
    await tester.pumpAndSettle();
  }

  testWidgets('search flow reaches a verse and highlights it', (tester) async {
    await pumpReadingApp(tester);

    expect(find.text('Génesis 1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'test');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, AppStrings.search));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.searchResults), findsOneWidget);
    expect(find.text('Génesis 1:1'), findsOneWidget);
    expect(find.textContaining('Test verse text'), findsOneWidget);

    var hasHighlight = false;
    final richText = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Test verse text'),
      ),
    );
    richText.text.visitChildren((span) {
      if (span is TextSpan &&
          span.style?.backgroundColor == AppColors.goldAccent &&
          span.style?.color == AppColors.darkText) {
        hasHighlight = true;
      }
      return true;
    });
    expect(hasHighlight, isTrue);

    expect(
      find.byWidgetPredicate((widget) => widget is PopScope && widget.canPop),
      findsNothing,
    );
  });

  testWidgets('focus screen jumps and returns to results', (tester) async {
    await pumpReadingApp(tester);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'test');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, AppStrings.search));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Génesis 1:1'));
    await tester.pumpAndSettle();

    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.text(AppStrings.backToResults), findsOneWidget);

    await tester.tap(find.text(AppStrings.backToResults));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.searchResults), findsOneWidget);
    expect(find.text('Génesis 1:1'), findsOneWidget);
  });

  testWidgets('progress button is hidden on the pushed focus reading', (
    tester,
  ) async {
    await pumpReadingApp(tester);

    expect(find.byType(ReadingProgressButton), findsOneWidget);

    await jumpToFirstResult(tester);

    expect(find.byType(ReadingProgressButton), findsNothing);
    expect(find.text(AppStrings.backToResults), findsOneWidget);
  });

  testWidgets('consultation screen blocks chapter navigation by swipe', (
    tester,
  ) async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('genesis', 2)).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(
          book: 'genesis',
          chapter: 2,
          verse: 1,
          text: 'Chapter two text',
        ),
      ]),
    );

    await pumpReadingApp(tester);
    await jumpToFirstResult(tester);

    expect(find.text(AppStrings.backToResults), findsOneWidget);
    expect(find.text(AppStrings.backToMyReading), findsOneWidget);
    expect(find.byType(ChapterNavigation), findsNothing);
    expect(find.byType(ConsultationContinueButton), findsOneWidget);

    await tester.drag(find.byType(SwipeableReadingBody), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Génesis 2'), findsNothing);
    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.textContaining('Chapter two text'), findsNothing);
  });

  testWidgets('green pill returns to my current reading and ends the search '
      'session', (tester) async {
    await pumpReadingApp(tester);
    await jumpToFirstResult(tester);

    await tester.tap(find.text(AppStrings.backToMyReading));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.backToMyReading), findsNothing);
    expect(find.text(AppStrings.backToResults), findsNothing);
    expect(find.text(AppStrings.searchResults), findsNothing);
    expect(find.byType(ConsultationContinueButton), findsNothing);
    expect(find.byType(ReadingFocusActions), findsNothing);
    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.byType(ReadingProgressButton), findsOneWidget);
  });

  testWidgets('continue-from-here opens the real reading at the consulted '
      'verse', (tester) async {
    await pumpReadingApp(tester);
    await jumpToFirstResult(tester);

    await tester.tap(find.byType(ConsultationContinueButton));
    await tester.pumpAndSettle();

    expect(find.byType(ReadingProgressButton), findsOneWidget);
    expect(find.text(AppStrings.percent(0)), findsOneWidget);
    expect(find.text(AppStrings.backToResults), findsNothing);
    expect(find.byType(ConsultationContinueButton), findsNothing);
    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.textContaining('Test verse text'), findsOneWidget);
  });

  testWidgets('continue-from-here keeps an already-read chapter at 100 %', (
    tester,
  ) async {
    when(() => getChapterProgress('genesis', 1)).thenAnswer(
      (_) async => const Right<Failure, ChapterProgressEntity?>(
        ChapterProgressEntity(
          book: 'genesis',
          chapter: 1,
          lastVerseRead: 1,
          isComplete: true,
        ),
      ),
    );

    await pumpReadingApp(tester);
    await jumpToFirstResult(tester);

    await tester.tap(find.byType(ConsultationContinueButton));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(ReadingProgressButton.circleKey),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
  });

  testWidgets('continue-from-here starts a partially read chapter at 0 %', (
    tester,
  ) async {
    when(() => getChapterVerses('genesis', 1)).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Uno'),
        VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'Dos'),
        VerseEntity(book: 'genesis', chapter: 1, verse: 3, text: 'Tres'),
        VerseEntity(book: 'genesis', chapter: 1, verse: 4, text: 'Cuatro'),
      ]),
    );
    when(() => getChapterProgress('genesis', 1)).thenAnswer(
      (_) async => const Right<Failure, ChapterProgressEntity?>(
        ChapterProgressEntity(
          book: 'genesis',
          chapter: 1,
          lastVerseRead: 1,
          isComplete: false,
        ),
      ),
    );

    await pumpReadingApp(tester);
    await jumpToFirstResult(tester);

    await tester.tap(find.byType(ConsultationContinueButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.percent(0)), findsOneWidget);
    expect(find.text(AppStrings.percent(25)), findsNothing);
  });

  testWidgets('aborting a second search hides the back-to-results button', (
    tester,
  ) async {
    await pumpReadingApp(tester);
    await jumpToFirstResult(tester);

    expect(find.text(AppStrings.backToResults), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'test');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, AppStrings.search));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.searchResults), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.back));
    await tester.pumpAndSettle();

    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.text(AppStrings.backToResults), findsNothing);
    expect(find.text(AppStrings.backToMyReading), findsOneWidget);
  });

  testWidgets(
    'changing book through the passage picker hides the back-to-results button',
    (tester) async {
      when(() => getChapterCount('revelation'))
          .thenAnswer((_) async => const Right<Failure, int>(22));
      when(() => getChapterVerses('revelation', 1)).thenAnswer(
        (_) async => const Right<Failure, List<VerseEntity>>([
          VerseEntity(
            book: 'revelation',
            chapter: 1,
            verse: 1,
            text: 'Revelation one text',
          ),
        ]),
      );

      await pumpReadingApp(tester);
      await jumpToFirstResult(tester);

      expect(find.text(AppStrings.backToResults), findsOneWidget);

      await tester.tap(find.text('Génesis 1'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(PassagePickerHeader),
          matching: find.text('Génesis'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('NT'));
      await tester.pumpAndSettle();

      final revelation = find.descendant(
        of: find.byType(BookChipGrid),
        matching: find.text('Apocalipsis'),
      );
      await tester.dragUntilVisible(
        revelation,
        find.byType(BookChipGrid),
        const Offset(0, -300),
      );
      await tester.tap(revelation);
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(NumberChipGrid),
          matching: find.text('1'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(NumberChipGrid),
          matching: find.text('1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apocalipsis 1'), findsOneWidget);
      expect(find.text(AppStrings.backToResults), findsNothing);
      expect(find.text(AppStrings.backToMyReading), findsOneWidget);
      expect(find.byType(ConsultationContinueButton), findsOneWidget);
    },
  );
}

class _MockGetChapterVerses extends Mock implements GetChapterVerses {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockGetReadingProgress extends Mock implements GetReadingProgress {}

class _MockSaveReadingProgress extends Mock implements SaveReadingProgress {}

class _MockGetReadingSettings extends Mock implements GetReadingSettings {}

class _MockSaveReadingSettings extends Mock implements SaveReadingSettings {}

class _MockSearchVerses extends Mock implements SearchVerses {}

class _MockGetChapterProgress extends Mock implements GetChapterProgress {}

class _MockSaveChapterProgress extends Mock implements SaveChapterProgress {}

class _MockGetChapterHighlights extends Mock implements GetChapterHighlights {}

class _MockAddVerseHighlight extends Mock implements AddVerseHighlight {}

class _MockUpdateVerseHighlight extends Mock implements UpdateVerseHighlight {}

class _MockDeleteVerseHighlight extends Mock implements DeleteVerseHighlight {}

class _MockRecordDailyReadingEvent extends Mock
    implements RecordDailyReadingEvent {}
