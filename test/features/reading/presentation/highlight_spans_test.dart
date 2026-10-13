import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/theme/highlight_palette.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/presentation/widgets/highlight_spans.dart';

const _baseStyle = TextStyle(fontSize: 20);

VerseHighlightEntity _highlight({
  required int start,
  required int end,
  HighlightColor color = HighlightColor.green,
  int updatedAt = 1000,
}) => VerseHighlightEntity(
  book: 'genesis',
  chapter: 1,
  verse: 1,
  startOffset: start,
  endOffset: end,
  color: color,
  createdAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
);

List<InlineSpan> _spans(String text, List<VerseHighlightEntity> highlights) =>
    HighlightSpans.fromVerse(
      text: text,
      highlights: highlights,
      baseStyle: _baseStyle,
    );

BoxDecoration _boxDecoration(InlineSpan span) {
  final container = (span as WidgetSpan).child as Container;
  return container.decoration! as BoxDecoration;
}

String _boxText(InlineSpan span) {
  final container = (span as WidgetSpan).child as Container;
  return (container.child as Text).data!;
}

void main() {
  test('returns the whole text unstyled when there are no highlights', () {
    final spans = _spans('paz sea', const []);

    expect(spans, hasLength(1));
    expect((spans.single as TextSpan).text, 'paz sea');
    expect(spans.single.style, _baseStyle);
  });

  test('returns no spans for empty text', () {
    expect(_spans('', [_highlight(start: 0, end: 0)]), isEmpty);
  });

  test('boxes only the highlighted range and keeps the rest base', () {
    final spans = _spans('paz sea', [_highlight(start: 0, end: 3)]);

    expect(spans, hasLength(2));
    expect(_boxText(spans.first), 'paz');
    final box = _boxDecoration(spans.first);
    expect(box.color, HighlightPalette.background(HighlightColor.green));
    expect(
      (box.border! as Border).top.color,
      HighlightPalette.base(HighlightColor.green),
    );
    expect((spans.last as TextSpan).text, ' sea');
    expect(spans.last.style, _baseStyle);
  });

  test('the most recent highlight wins in the overlapping region', () {
    final spans = _spans('abcdefgh', [
      _highlight(
        start: 0,
        end: 5,
        color: HighlightColor.yellow,
        updatedAt: 1000,
      ),
      _highlight(start: 3, end: 6, color: HighlightColor.blue, updatedAt: 2000),
    ]);

    expect(spans, hasLength(3));
    expect(_boxText(spans[0]), 'abc');
    expect(
      _boxDecoration(spans[0]).color,
      HighlightPalette.background(HighlightColor.yellow),
    );
    expect(_boxText(spans[1]), 'def');
    expect(
      _boxDecoration(spans[1]).color,
      HighlightPalette.background(HighlightColor.blue),
    );
    expect((spans[2] as TextSpan).text, 'gh');
  });

  test('clamps offsets that exceed the text bounds', () {
    final spans = _spans('abc', [_highlight(start: -2, end: 99)]);

    expect(spans, hasLength(1));
    expect(_boxText(spans.single), 'abc');
  });

  test('renderedLength counts a highlighted run as one placeholder', () {
    final length = HighlightSpans.renderedLength(
      text: 'paz sea',
      highlights: [_highlight(start: 0, end: 3)],
    );

    expect(length, 5);
  });

  test('toTextOffset maps rendered positions back to text offsets', () {
    const text = 'paz sea';
    final highlights = [_highlight(start: 0, end: 3)];

    int map(int renderedOffset) => HighlightSpans.toTextOffset(
      text: text,
      highlights: highlights,
      renderedOffset: renderedOffset,
    );

    expect(map(0), 0);
    expect(map(1), 3);
    expect(map(2), 4);
    expect(map(3), 5);
    expect(map(5), 7);
  });
}
