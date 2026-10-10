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

import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_count.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_chapter_verses.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/get_reading_settings.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_progress.dart';
import 'package:bibliapp/features/reading/domain/usecases/save_reading_settings.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/main.dart';

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
      const ReadingProgressEntity(
        lastBook: 'genesis',
        lastChapter: 1,
        lastVerse: 1,
        timestamp: 0,
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
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('shows chapter data and adjusts reading text', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.textContaining('Test verse text'), findsOneWidget);

    await tester.tap(find.text('A+'));
    await tester.pump();

    final verseRichText = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Test verse text'),
      ),
    );
    double? verseFontSize;
    (verseRichText.text as TextSpan).visitChildren((span) {
      if (span is TextSpan && span.text?.contains('Test verse text') == true) {
        verseFontSize = span.style?.fontSize;
      }
      return true;
    });
    expect(verseFontSize, 21);
  });

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

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Génesis 1'), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text('Génesis 2'), findsOneWidget);
    expect(find.textContaining('Second chapter verse'), findsOneWidget);
  });
}

class _MockGetChapterVerses extends Mock implements GetChapterVerses {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockGetReadingProgress extends Mock implements GetReadingProgress {}

class _MockSaveReadingProgress extends Mock implements SaveReadingProgress {}

class _MockGetReadingSettings extends Mock implements GetReadingSettings {}

class _MockSaveReadingSettings extends Mock implements SaveReadingSettings {}
