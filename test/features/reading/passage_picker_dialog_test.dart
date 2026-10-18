import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/app/di/get_it.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/app/router/go_router.dart';
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
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/book_chip_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/number_chip_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_header.dart';
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
    getChapterProgress = _MockGetChapterProgress();
    saveChapterProgress = _MockSaveChapterProgress();
    getChapterHighlights = _MockGetChapterHighlights();
    addVerseHighlight = _MockAddVerseHighlight();
    updateVerseHighlight = _MockUpdateVerseHighlight();
    deleteVerseHighlight = _MockDeleteVerseHighlight();
    recordDailyReadingEvent = _MockRecordDailyReadingEvent();
    checkInternetConnectivity = _MockCheckInternetConnectivity();
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
        .thenAnswer((_) async => const Right<Failure, int>(50));
    when(() => getChapterVerses(any(), any()))
        .thenAnswer((_) async => const Right<Failure, List<VerseEntity>>([]));
    when(() => getChapterVerses('genesis', 1)).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Test verse'),
      ]),
    );
    when(() => getChapterVerses('genesis', 3)).thenAnswer(
      (_) async => Right<Failure, List<VerseEntity>>(
        List.generate(
          5,
          (index) => VerseEntity(
            book: 'genesis',
            chapter: 3,
            verse: index + 1,
            text: 'Verse',
          ),
        ),
      ),
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
        checkInternetConnectivity: checkInternetConnectivity,
      ),
    );
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

  testWidgets('opens the picker and navigates book/chapter/verse', (
    tester,
  ) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Génesis 1'));
    await tester.pumpAndSettle();

    expect(_headerTitle('Génesis'), findsOneWidget);
    expect(find.text('Seleccionar pasaje'), findsNothing);
    expect(find.byType(ChapterGrid), findsOneWidget);

    await tester.tap(find.text('AT'));
    await tester.pumpAndSettle();

    expect(find.byType(BookChipGrid), findsOneWidget);
    expect(_headerTitle('Seleccionar pasaje'), findsOneWidget);
    final genesisChip = find.descendant(
      of: find.byType(BookChipGrid),
      matching: find.text('Génesis'),
    );
    final exodusChip = find.descendant(
      of: find.byType(BookChipGrid),
      matching: find.text('Éxodo'),
    );
    expect(genesisChip, findsOneWidget);
    expect(exodusChip, findsOneWidget);

    await tester.tap(genesisChip);
    await tester.pumpAndSettle();

    expect(_headerTitle('Génesis'), findsOneWidget);
    expect(find.byType(NumberChipGrid), findsOneWidget);

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(_headerTitle('Génesis Cap. 3'), findsOneWidget);
    expect(find.byType(NumberChipGrid), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Seleccionar pasaje'), findsNothing);
    expect(find.text('Génesis 3'), findsOneWidget);
    expect(find.textContaining('Verse'), findsWidgets);
  });

  testWidgets('shows the selected book and chapter in the header title', (
    tester,
  ) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Génesis 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('AT'));
    await tester.pumpAndSettle();

    final ruthChip = find.descendant(
      of: find.byType(BookChipGrid),
      matching: find.text('Rut'),
    );
    await tester.dragUntilVisible(
      ruthChip,
      find.byType(BookChipGrid),
      const Offset(0, -300),
    );
    await tester.tap(ruthChip);
    await tester.pumpAndSettle();

    expect(_headerTitle('Rut'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    expect(_headerTitle('Rut Cap. 5'), findsOneWidget);

    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();

    expect(_headerTitle('Rut'), findsOneWidget);
  });

  testWidgets('shows the new testament book list restricted to NT', (
    tester,
  ) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Génesis 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('NT'));
    await tester.pumpAndSettle();

    expect(find.byType(BookChipGrid), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(BookChipGrid),
        matching: find.text('Mateo'),
      ),
      findsOneWidget,
    );
    final apocalipsis = find.descendant(
      of: find.byType(BookChipGrid),
      matching: find.text('Apocalipsis'),
    );
    await tester.dragUntilVisible(
      apocalipsis,
      find.byType(BookChipGrid),
      const Offset(0, -300),
    );
    expect(apocalipsis, findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(BookChipGrid),
        matching: find.text('Génesis'),
      ),
      findsNothing,
    );
  });
}

Finder _headerTitle(String title) => find.descendant(
  of: find.byType(PassagePickerHeader),
  matching: find.text(title),
);

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
