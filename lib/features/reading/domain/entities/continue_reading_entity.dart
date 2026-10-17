/// Where the user should continue reading, resolved from the latest reading
/// mark: a recent partial chapter keeps its position; otherwise it is the
/// chapter after the latest completed one.
class ContinueReadingEntity {
  final String book; // stable English id ('genesis')
  final int chapter;

  /// When set, the chapter has a partial mark up to this verse.
  final int? lastVerseRead;

  const ContinueReadingEntity({
    required this.book,
    required this.chapter,
    this.lastVerseRead,
  });

  bool get isPartial => lastVerseRead != null;
}
