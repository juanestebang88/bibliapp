/// Aggregated reading activity for one local day.
class ReadingDayEntity {
  /// Local date of the device ('yyyy-MM-dd').
  final String date;
  final int chaptersCount;
  final int versesCount;

  const ReadingDayEntity({
    required this.date,
    required this.chaptersCount,
    required this.versesCount,
  });

  bool get hasRead => versesCount > 0 || chaptersCount > 0;

  @override
  bool operator ==(Object other) =>
      other is ReadingDayEntity &&
      other.date == date &&
      other.chaptersCount == chaptersCount &&
      other.versesCount == versesCount;

  @override
  int get hashCode => Object.hash(date, chaptersCount, versesCount);
}
