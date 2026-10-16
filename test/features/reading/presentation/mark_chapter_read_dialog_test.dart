import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/reading/presentation/widgets/mark_chapter_read_dialog.dart';

void main() {
  Future<void> pumpDialog(
    WidgetTester tester, {
    int totalVerses = 30,
    int initialVerse = 7,
    bool complete = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(
          body: Center(
            child: MarkChapterReadDialog(
              totalVerses: totalVerses,
              initialVerse: initialVerse,
              complete: complete,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  double fontSizeOf(WidgetTester tester, Finder finder) =>
      tester.renderObject<RenderParagraph>(finder).text.style!.fontSize!;

  group('text sizes', () {
    testWidgets('renders the title at the larger title step (24)', (
      tester,
    ) async {
      await pumpDialog(tester);

      expect(fontSizeOf(tester, find.text(AppStrings.chapterProgress)), 24);
    });

    testWidgets('renders the hint at labelMedium (14)', (tester) async {
      await pumpDialog(tester);

      expect(fontSizeOf(tester, find.text(AppStrings.upToWhichVerse)), 14);
    });

    testWidgets('renders the verse number at the larger title step (24)', (
      tester,
    ) async {
      await pumpDialog(tester);

      expect(fontSizeOf(tester, find.text('7')), 24);
    });

    testWidgets('renders the action buttons at 16', (tester) async {
      await pumpDialog(tester);

      expect(fontSizeOf(tester, find.text(AppStrings.markChapterComplete)), 16);
      expect(fontSizeOf(tester, find.text(AppStrings.saveUpToVerse(7))), 16);
    });

    testWidgets('renders the unmark hint and button at the larger steps', (
      tester,
    ) async {
      await pumpDialog(tester, complete: true);

      expect(fontSizeOf(tester, find.text(AppStrings.verseCount(30))), 14);
      expect(fontSizeOf(tester, find.text(AppStrings.unmarkChapter)), 16);
    });
  });

  group('step buttons', () {
    testWidgets('use 24 px icons inside 12 px padding', (tester) async {
      await pumpDialog(tester);

      for (final icon in [Icons.remove, Icons.add]) {
        final iconFinder = find.byIcon(icon);
        expect(tester.widget<Icon>(iconFinder).size, AppSpacing.xl);

        final hitArea = find.ancestor(
          of: iconFinder,
          matching: find.byType(InkWell),
        );
        expect(
          tester.getSize(hitArea),
          const Size(
            AppSpacing.xl + AppSpacing.md * 2,
            AppSpacing.xl + AppSpacing.md * 2,
          ),
        );
      }
    });

    testWidgets('increment and decrement update the number and the label', (
      tester,
    ) async {
      await pumpDialog(tester, initialVerse: 7);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('8'), findsOneWidget);
      expect(find.text(AppStrings.saveUpToVerse(8)), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
      expect(find.text(AppStrings.saveUpToVerse(7)), findsOneWidget);
    });

    testWidgets('clamps the selector to the 1..total range', (tester) async {
      await pumpDialog(tester, totalVerses: 30, initialVerse: 999);

      expect(find.text('30'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('30'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('29'), findsOneWidget);
    });
  });
}
