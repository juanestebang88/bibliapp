import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';

void main() {
  final base = VerseHighlightEntity(
    id: 1,
    book: 'genesis',
    chapter: 1,
    verse: 1,
    startOffset: 2,
    endOffset: 5,
    color: HighlightColor.green,
    createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(2000),
  );

  test('covers an index within the exclusive end offset', () {
    expect(base.covers(2), isTrue);
    expect(base.covers(4), isTrue);
    expect(base.covers(5), isFalse);
    expect(base.covers(1), isFalse);
  });

  test('copyWith replaces only the provided fields', () {
    final copy = base.copyWith(color: HighlightColor.blue, id: 9);

    expect(copy.color, HighlightColor.blue);
    expect(copy.id, 9);
    expect(copy.book, base.book);
    expect(copy.startOffset, base.startOffset);
    expect(copy.endOffset, base.endOffset);
    expect(copy.createdAt, base.createdAt);
    expect(copy.updatedAt, base.updatedAt);
  });

  test('equality is based on every field', () {
    expect(
      base,
      VerseHighlightEntity(
        id: 1,
        book: 'genesis',
        chapter: 1,
        verse: 1,
        startOffset: 2,
        endOffset: 5,
        color: HighlightColor.green,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(2000),
      ),
    );
    expect(base, isNot(base.copyWith(color: HighlightColor.copper)));
  });
}
