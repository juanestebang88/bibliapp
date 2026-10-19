// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/app/di/get_it.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/app/router/go_router.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
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
import 'package:bibliapp/features/reading/domain/usecases/get_books_reading_stats.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapters_series.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_overview.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_progress_button.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:bibliapp/main.dart';

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
  late _MockGetReadingOverview getReadingOverview;
  late _MockGetChaptersSeries getChaptersSeries;
  late _MockGetBooksReadingStats getBooksReadingStats;

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
    registerFallbackValue(<String>[]);
    registerFallbackValue(DateTime(2026));
  });

  setUp(() async {
    await getIt.reset();
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
    getReadingOverview = _MockGetReadingOverview();
    getChaptersSeries = _MockGetChaptersSeries();
    getBooksReadingStats = _MockGetBooksReadingStats();
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
    when(() => getChapterProgress(any(), any())).thenAnswer(
      (_) async => const Right<Failure, ChapterProgressEntity?>(null),
    );
    when(() => saveChapterProgress(any()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
    when(() => getChapterHighlights(any(), any())).thenAnswer(
      (_) async => const Right<Failure, List<VerseHighlightEntity>>([]),
    );
    when(
      () => getReadingOverview(any(), today: any(named: 'today')),
    ).thenAnswer(
      (_) async =>
          const Right<Failure, ReadingOverviewEntity>(ReadingOverviewEntity()),
    );
    when(
      () => getChaptersSeries(
        books: any(named: 'books'),
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer(
      (_) async => const Right<Failure, List<ChaptersSeriesPointEntity>>([
        ChaptersSeriesPointEntity(date: '2026-10-19', chaptersCount: 0),
      ]),
    );
    when(() => getBooksReadingStats()).thenAnswer(
      (_) async => Right([
        BookReadingStatsEntity(
          book: 'genesis',
          completedChapters: 0,
          totalChapters: 50,
        ),
        BookReadingStatsEntity(
          book: 'malachi',
          completedChapters: 0,
          totalChapters: 4,
        ),
        BookReadingStatsEntity(
          book: 'revelation',
          completedChapters: 0,
          totalChapters: 22,
        ),
      ]),
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
        checkInternetConnectivity: checkInternetConnectivity,
      ),
    );
    getIt.registerFactory(
      () => StatsCubit(
        getReadingOverview: getReadingOverview,
        getChaptersSeries: getChaptersSeries,
        getBooksReadingStats: getBooksReadingStats,
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('shows chapter data and adjusts reading text', (tester) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.textContaining('Test verse text'), findsOneWidget);

    await tester.tap(find.text('A+'));
    await tester.pump();

    final verseSelectable = tester.widget<SelectableText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.textSpan?.toPlainText().contains('Test verse text') == true,
      ),
    );
    double? verseFontSize;
    verseSelectable.textSpan!.visitChildren((span) {
      if (span is TextSpan && span.text?.contains('Test verse text') == true) {
        verseFontSize = span.style?.fontSize;
      }
      return true;
    });
    expect(verseFontSize, 21);
  });

  testWidgets('shows the progress button and its percentage on the root reading'
      ' screen', (tester) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(ReadingProgressButton), findsOneWidget);
    expect(find.text(AppStrings.percent(0)), findsOneWidget);

    final buttonRect = tester.getRect(find.byType(ReadingProgressButton));
    final appRect = tester.getRect(find.byType(MaterialApp));
    expect(buttonRect.center.dx, greaterThan(appRect.center.dx));
    expect(buttonRect.center.dy, greaterThan(appRect.center.dy));
  });

  testWidgets(
    'starts at the saved percentage when the chapter has partial progress',
    (tester) async {
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

      appRouter.go('/reading');
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.percent(25)), findsOneWidget);
    },
  );

  testWidgets('swipes to the next chapter', (tester) async {
    when(() => getChapterCount('genesis'))
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses('genesis', 2)).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(
          book: 'genesis',
          chapter: 2,
          verse: 1,
          text: 'Second chapter verse',
        ),
      ]),
    );

    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Génesis 1'), findsOneWidget);

    await tester.drag(find.byType(SwipeableReadingBody), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Génesis 2'), findsOneWidget);
    expect(find.textContaining('Second chapter verse'), findsOneWidget);
  });

  testWidgets('toolbar "Estadísticas" opens the stats screen', (tester) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.statistics));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.statsTitle), findsOneWidget);
    expect(find.text(AppStrings.tabMyProgress), findsOneWidget);
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

class _MockGetReadingOverview extends Mock implements GetReadingOverview {}

class _MockGetChaptersSeries extends Mock implements GetChaptersSeries {}

class _MockGetBooksReadingStats extends Mock implements GetBooksReadingStats {}
