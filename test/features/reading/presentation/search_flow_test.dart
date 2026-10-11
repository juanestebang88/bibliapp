import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/router/go_router.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/search_verses.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/search_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/book_chip_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/number_chip_grid.dart';
import 'package:bibliapp/main.dart';

void main() {
  late _MockGetChapterVerses getChapterVerses;
  late _MockGetChapterCount getChapterCount;
  late _MockGetReadingProgress getReadingProgress;
  late _MockSaveReadingProgress saveReadingProgress;
  late _MockGetReadingSettings getReadingSettings;
  late _MockSaveReadingSettings saveReadingSettings;
  late _MockSearchVerses searchVerses;

  setUpAll(() {
    registerFallbackValue(const ReadingSettingsEntity());
    registerFallbackValue(
      const ReadingProgressEntity(lastBook: 'genesis', lastChapter: 1),
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
    when(() => getReadingProgress()).thenAnswer(
      (_) async => const Right<Failure, ReadingProgressEntity?>(null),
    );
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
    getIt.registerFactory(
      () => ReadingCubit(
        getChapterVerses: getChapterVerses,
        getChapterCount: getChapterCount,
        getReadingProgress: getReadingProgress,
        saveReadingProgress: saveReadingProgress,
        getReadingSettings: getReadingSettings,
        saveReadingSettings: saveReadingSettings,
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

  testWidgets('changing chapter hides the back-to-results button', (
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

    await tester.tap(find.byTooltip('Capítulo siguiente'));
    await tester.pumpAndSettle();

    expect(find.text('Génesis 2'), findsOneWidget);
    expect(find.text(AppStrings.backToResults), findsNothing);
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
      expect(find.text('Seleccionar pasaje'), findsOneWidget);

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
