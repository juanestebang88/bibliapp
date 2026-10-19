import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';

BookReadingStatsEntity _book({
  required int completed,
  required int total,
  DateTime? firstMarkAt,
}) => BookReadingStatsEntity(
  book: 'genesis',
  completedChapters: completed,
  totalChapters: total,
  firstMarkAt: firstMarkAt,
);

/// Reading state getter (spec 20): never marked, marked without completing
/// and fully completed.
void main() {
  test('a book without marks and without completions is not started', () {
    expect(_book(completed: 0, total: 50).status, BookReadingStatus.notStarted);
  });

  test('a book with marks but unfinished chapters is in progress', () {
    expect(
      _book(completed: 4, total: 50, firstMarkAt: DateTime(2026, 9, 1)).status,
      BookReadingStatus.inProgress,
    );
  });

  test('a book with every chapter completed is completed', () {
    expect(
      _book(completed: 4, total: 4, firstMarkAt: DateTime(2026, 9, 1)).status,
      BookReadingStatus.completed,
    );
  });

  test('completed chapters without a total count as in progress', () {
    expect(_book(completed: 3, total: 0).status, BookReadingStatus.inProgress);
  });
}
