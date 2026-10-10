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
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/book_chip_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/number_chip_grid.dart';
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
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Génesis 1'));
    await tester.pumpAndSettle();

    expect(find.text('Seleccionar pasaje'), findsOneWidget);
    expect(find.byType(ChapterGrid), findsOneWidget);

    await tester.tap(find.text('AT'));
    await tester.pumpAndSettle();

    expect(find.byType(BookChipGrid), findsOneWidget);
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

    expect(find.byType(NumberChipGrid), findsOneWidget);

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(find.byType(NumberChipGrid), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    expect(find.text('Seleccionar pasaje'), findsNothing);
    expect(find.text('Génesis 3'), findsOneWidget);
    expect(find.textContaining('Verse'), findsWidgets);
  });

  testWidgets('shows the new testament book list restricted to NT', (
    tester,
  ) async {
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

class _MockGetChapterVerses extends Mock implements GetChapterVerses {}

class _MockGetChapterCount extends Mock implements GetChapterCount {}

class _MockGetReadingProgress extends Mock implements GetReadingProgress {}

class _MockSaveReadingProgress extends Mock implements SaveReadingProgress {}

class _MockGetReadingSettings extends Mock implements GetReadingSettings {}

class _MockSaveReadingSettings extends Mock implements SaveReadingSettings {}
