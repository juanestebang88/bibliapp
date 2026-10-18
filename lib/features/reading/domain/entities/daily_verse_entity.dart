/// A verse picked as the "daily verse": kept identical for the whole day.
class DailyVerseEntity {
  final String book; // stable English id ('john')
  final int chapter;
  final int verse;
  final String text; // verse text (Spanish content)

  const DailyVerseEntity({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  @override
  bool operator ==(Object other) =>
      other is DailyVerseEntity &&
      other.book == book &&
      other.chapter == chapter &&
      other.verse == verse &&
      other.text == text;

  @override
  int get hashCode => Object.hash(book, chapter, verse, text);
}
