import 'package:equatable/equatable.dart';

/// Colors available for user verse highlights (spec 11).
enum HighlightColor { green, blue, yellow, copper }

/// Domain entity representing a persisted user highlight over a verse range.
///
/// Offsets are 0-based and relative to the verse text (excluding the verse
/// number prefix). [endOffset] is exclusive, so a whole-verse highlight spans
/// `[0, verseText.length)`.
class VerseHighlightEntity extends Equatable {
  final int? id;
  final String book;
  final int chapter;
  final int verse;
  final int startOffset;
  final int endOffset;
  final HighlightColor color;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VerseHighlightEntity({
    this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.startOffset,
    required this.endOffset,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  bool covers(int index) => index >= startOffset && index < endOffset;

  /// Whether this highlight spans the whole verse text of [textLength].
  bool isWholeVerse(int textLength) =>
      startOffset <= 0 && endOffset >= textLength;

  VerseHighlightEntity copyWith({
    int? id,
    String? book,
    int? chapter,
    int? verse,
    int? startOffset,
    int? endOffset,
    HighlightColor? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VerseHighlightEntity(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    book,
    chapter,
    verse,
    startOffset,
    endOffset,
    color,
    createdAt,
    updatedAt,
  ];
}
