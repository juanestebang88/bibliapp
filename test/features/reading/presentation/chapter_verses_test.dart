import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_verses.dart';

void main() {
  List<VerseEntity> buildVerses(int count) => List.generate(
    count,
    (index) => VerseEntity(
      book: 'genesis',
      chapter: 1,
      verse: index + 1,
      text:
          'Versículo ${index + 1} con texto suficiente para ocupar varias '
          'líneas en la pantalla.',
    ),
  );

  ReadingState buildState(List<VerseEntity> verses) => ReadingState(
    chapterVerses: verses,
    currentBook: 'genesis',
    currentChapter: 1,
  );

  Future<void> pumpChapter(
    WidgetTester tester, {
    required ReadingState state,
    required ValueChanged<int> onVisibleVerseChanged,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(
          body: ChapterVerses(
            state: state,
            onVisibleVerseChanged: onVisibleVerseChanged,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('does not report a visible verse before the first scroll', (
    tester,
  ) async {
    final reported = <int>[];
    await pumpChapter(
      tester,
      state: buildState(buildVerses(50)),
      onVisibleVerseChanged: reported.add,
    );

    expect(reported, isEmpty);
  });

  testWidgets('reports the last visible verse after scrolling', (tester) async {
    final reported = <int>[];
    await pumpChapter(
      tester,
      state: buildState(buildVerses(50)),
      onVisibleVerseChanged: reported.add,
    );

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();

    expect(reported, isNotEmpty);
    expect(reported.last, greaterThan(1));
  });

  testWidgets('returns to 0 when the chapter is scrolled back to the top', (
    tester,
  ) async {
    final reported = <int>[];
    await pumpChapter(
      tester,
      state: buildState(buildVerses(50)),
      onVisibleVerseChanged: reported.add,
    );

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    expect(reported.last, greaterThan(1));

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 600));
    await tester.pumpAndSettle();

    expect(reported.last, 0);
  });
}
