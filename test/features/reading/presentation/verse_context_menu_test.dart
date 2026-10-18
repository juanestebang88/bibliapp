import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/verse_context_menu.dart';

class _MockReadingCubit extends Mock implements ReadingCubit {}

const _verse = VerseEntity(book: 'john', chapter: 3, verse: 16, text: 'paz');

void main() {
  late _MockReadingCubit readingCubit;

  setUp(() {
    readingCubit = _MockReadingCubit();
    when(() => readingCubit.state).thenReturn(const ReadingState());
    when(() => readingCubit.stream)
        .thenAnswer((_) => const Stream<ReadingState>.empty());
    when(() => readingCubit.checkRaeConnectivity(any()))
        .thenAnswer((_) async {});
    when(() => readingCubit.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          null,
        );
  });

  // The short verse text keeps the long-press selection ("paz", offsets
  // 0..3) easy to reason about.
  const selectionVerse = VerseEntity(
    book: 'john',
    chapter: 3,
    verse: 3,
    text: 'paz',
  );

  Future<void> pumpMenu(
    WidgetTester tester, {
    List<VerseHighlightEntity> highlights = const [],
    VerseEntity verse = _verse,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ReadingCubit>(
          create: (_) => readingCubit,
          child: Scaffold(
            body: Center(
              child: SelectableText.rich(
                TextSpan(text: verse.text),
                contextMenuBuilder: (context, editableTextState) =>
                    VerseContextMenu(
                      editableTextState: editableTextState,
                      verse: verse,
                      highlights: highlights,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.longPress(find.byType(SelectableText));
    await tester.pumpAndSettle();
  }

  // Long press on the first word and drag to the right to extend the selection
  // by whole words, replacing the single-word selection made by [pumpMenu].
  Future<void> selectPhrase(WidgetTester tester) async {
    final topLeft = tester.getTopLeft(find.byType(SelectableText));
    final gesture = await tester.startGesture(topLeft + const Offset(2, 8));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    await gesture.moveBy(const Offset(240, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
  }

  // Each custom toolbar button shows an icon next to its label, so the labels
  // are read from the text inside the rendered buttons.
  List<String> menuLabels(WidgetTester tester) {
    return tester
        .widgetList<Text>(
          find.descendant(
            of: find.byType(TextSelectionToolbarTextButton),
            matching: find.byType(Text),
          ),
        )
        .map((text) => text.data!)
        .toList(growable: false);
  }

  VerseHighlightEntity highlight({
    int startOffset = 0,
    int endOffset = 3,
    HighlightColor color = HighlightColor.green,
  }) => VerseHighlightEntity(
    book: selectionVerse.book,
    chapter: selectionVerse.chapter,
    verse: selectionVerse.verse,
    startOffset: startOffset,
    endOffset: endOffset,
    color: color,
    createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(1000),
  );

  testWidgets('shows the context actions in order', (tester) async {
    await pumpMenu(tester);

    expect(menuLabels(tester), [
      AppStrings.copyWord,
      AppStrings.shareVerse,
      AppStrings.searchInRae,
      AppStrings.underline,
      AppStrings.underlineVerse,
    ]);
  });

  testWidgets('keeps every action reachable on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpMenu(tester);

    for (final label in [
      AppStrings.copyWord,
      AppStrings.shareVerse,
      AppStrings.searchInRae,
      AppStrings.underline,
      AppStrings.underlineVerse,
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets('shows an icon next to every action', (tester) async {
    await pumpMenu(tester);

    final icons = tester.widgetList<Icon>(
      find.descendant(
        of: find.byType(TextSelectionToolbarTextButton),
        matching: find.byType(Icon),
      ),
    );
    expect(icons, hasLength(5));
  });

  testWidgets('shrinks the toolbar instead of spanning the screen width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpMenu(tester);

    final toolbar = find
        .ancestor(
          of: find.byType(TextSelectionToolbarTextButton).first,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Material &&
                widget.color == AppColors.contextMenuBackground,
          ),
        )
        .first;
    final width = tester.getSize(toolbar).width;
    expect(width, greaterThan(0));
    expect(width, lessThan(800));
  });

  testWidgets(
    'shows change color and remove underline first when the selection is inside a highlight',
    (tester) async {
      await pumpMenu(tester, verse: selectionVerse, highlights: [highlight()]);

      expect(menuLabels(tester), [
        AppStrings.changeColor,
        AppStrings.removeUnderline,
        AppStrings.copyWord,
        AppStrings.shareVerse,
        AppStrings.searchInRae,
        AppStrings.underline,
        AppStrings.underlineVerse,
      ]);
    },
  );

  testWidgets('hides the edit actions when no highlight intersects', (
    tester,
  ) async {
    await pumpMenu(tester, verse: selectionVerse, highlights: const []);

    expect(find.text(AppStrings.changeColor), findsNothing);
    expect(find.text(AppStrings.removeUnderline), findsNothing);
    expect(menuLabels(tester), [
      AppStrings.copyWord,
      AppStrings.shareVerse,
      AppStrings.searchInRae,
      AppStrings.underline,
      AppStrings.underlineVerse,
    ]);
  });

  testWidgets('uses the white surface and the app background blue text', (
    tester,
  ) async {
    await pumpMenu(tester);

    final element = tester.element(
      find.byType(TextSelectionToolbarTextButton).first,
    );
    final scheme = Theme.of(element).colorScheme;
    expect(scheme.surface, AppColors.contextMenuBackground);
    expect(scheme.onSurface, AppColors.contextMenuForeground);
  });

  testWidgets('copy word puts the selected word in the clipboard', (
    tester,
  ) async {
    String? copied;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
          }
          return null;
        });

    await pumpMenu(tester);
    await tester.tap(find.text(AppStrings.copyWord));
    await tester.pumpAndSettle();

    expect(copied, 'paz');
  });

  testWidgets('copies the whole selected phrase, not just the first word', (
    tester,
  ) async {
    String? copied;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
          }
          return null;
        });

    await pumpMenu(
      tester,
      verse: const VerseEntity(
        book: 'john',
        chapter: 3,
        verse: 16,
        text: 'la paz',
      ),
    );
    await selectPhrase(tester);
    await tester.tap(find.text(AppStrings.copyWord));
    await tester.pumpAndSettle();

    expect(copied, 'la paz');
  });

  testWidgets('shows search in RAE for a single word selection', (
    tester,
  ) async {
    await pumpMenu(tester);

    expect(find.text(AppStrings.searchInRae), findsOneWidget);
  });

  testWidgets('hides search in RAE when two or more words are selected', (
    tester,
  ) async {
    await pumpMenu(
      tester,
      verse: const VerseEntity(
        book: 'john',
        chapter: 3,
        verse: 16,
        text: 'la paz',
      ),
    );
    await selectPhrase(tester);

    expect(find.text(AppStrings.searchInRae), findsNothing);
  });

  testWidgets('hides search in RAE when more than two words are selected', (
    tester,
  ) async {
    await pumpMenu(
      tester,
      verse: const VerseEntity(
        book: 'john',
        chapter: 3,
        verse: 16,
        text: 'la paz sea contigo',
      ),
    );
    await selectPhrase(tester);

    expect(find.text(AppStrings.searchInRae), findsNothing);
  });

  testWidgets('share verse shares the verse text with its reference', (
    tester,
  ) async {
    String? shared;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          (call) async {
            if (call.method == 'share') {
              shared = (call.arguments as Map)['text'] as String?;
            }
            return null;
          },
        );

    await pumpMenu(tester);
    await tester.tap(find.text(AppStrings.shareVerse));
    await tester.pumpAndSettle();

    expect(shared, 'paz — Juan 3:16');
  });

  testWidgets('search in RAE asks the cubit to check connectivity', (
    tester,
  ) async {
    await pumpMenu(tester);
    await tester.tap(find.text(AppStrings.searchInRae));
    await tester.pumpAndSettle();

    verify(() => readingCubit.checkRaeConnectivity('paz')).called(1);
  });
}
