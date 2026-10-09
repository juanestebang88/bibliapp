import 'package:equatable/equatable.dart';

/// Domain entity representing a verse from the RV1960 Bible.
class VerseEntity extends Equatable {
  final String book;
  final int chapter;
  final int verse;
  final String text;
  final bool isVerseNumber;

  const VerseEntity({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    this.isVerseNumber = false,
  });

  @override
  List<Object> get props => [book, chapter, verse, text, isVerseNumber];

  @override
  String toString() =>
      'VerseEntity(book: $book, chapter: $chapter, verse: $verse)';
}
