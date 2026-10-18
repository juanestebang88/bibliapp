import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/features/reading/presentation/theme/highlight_palette.dart';
import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_verse_item.dart';

const _verse = VerseEntity(
  book: 'genesis',
  chapter: 1,
  verse: 1,
  text: 'paz sea',
);

VerseHighlightEntity _highlight(int start, int end, HighlightColor color) =>
    VerseHighlightEntity(
      book: 'genesis',
      chapter: 1,
      verse: 1,
      startOffset: start,
      endOffset: end,
      color: color,
      createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(1000),
    );

Future<void> _pump(
  WidgetTester tester,
  List<VerseHighlightEntity> highlights,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: appTheme(),
      home: Scaffold(
        body: ReadingVerseItem(
          verse: _verse,
          fontSize: 20,
          highlights: highlights,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

List<InlineSpan> _verseSpans(WidgetTester tester) {
  final selectable = tester.widget<SelectableText>(find.byType(SelectableText));
  return selectable.textSpan!.children!;
}

void main() {
  testWidgets('renders a highlighted word as a bordered box', (tester) async {
    await _pump(tester, [_highlight(0, 3, HighlightColor.green)]);

    final boxedSpans = _verseSpans(tester)
        .whereType<WidgetSpan>()
        .toList(growable: false);
    expect(boxedSpans, hasLength(1));

    final container = boxedSpans.single.child as Container;
    expect((container.child as Text).data, 'paz');
    final box = container.decoration! as BoxDecoration;
    expect(box.color, HighlightPalette.background(HighlightColor.green));
    expect(
      (box.border! as Border).top.color,
      HighlightPalette.base(HighlightColor.green),
    );
  });

  testWidgets('wraps a whole-verse highlight in a bordered container', (
    tester,
  ) async {
    await _pump(tester, [
      _highlight(0, _verse.text.length, HighlightColor.blue),
    ]);

    final decorated = tester
        .widgetList<Container>(find.byType(Container))
        .where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration && decoration.border != null;
        })
        .toList();

    expect(decorated, hasLength(1));
    final box = decorated.single.decoration! as BoxDecoration;
    expect(box.color, HighlightPalette.background(HighlightColor.blue));
    expect(
      (box.border! as Border).top.color,
      HighlightPalette.base(HighlightColor.blue),
    );
  });

  testWidgets('a whole-verse highlight does not draw an inline box', (
    tester,
  ) async {
    await _pump(tester, [
      _highlight(0, _verse.text.length, HighlightColor.copper),
    ]);

    expect(_verseSpans(tester).whereType<WidgetSpan>(), isEmpty);
  });
}
