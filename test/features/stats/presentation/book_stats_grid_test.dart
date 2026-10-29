import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_grid.dart';

BookReadingStatsEntity _stats(String book, int completed, int total) =>
    BookReadingStatsEntity(
      book: book,
      completedChapters: completed,
      totalChapters: total,
    );

void main() {
  testWidgets('renders one card per book, keeping the given order', (
    tester,
  ) async {
    final books = [
      _stats('genesis', 11, 50),
      _stats('exodus', 0, 40),
      _stats('leviticus', 27, 27),
      _stats('ruth', 0, 4),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: BookStatsGrid(books: books)),
        ),
      ),
    );
    await tester.pump();

    final names = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .whereType<String>()
        .toList();
    expect(
      names,
      containsAll([
        AppStrings.bookName('genesis'),
        AppStrings.bookName('ruth'),
        AppStrings.bookProgress(0, 40, 0),
        AppStrings.bookProgress(27, 27, 100),
      ]),
    );
  });
}
