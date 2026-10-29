import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/widgets/progress_ring.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_card.dart';

final _stats = BookReadingStatsEntity(
  book: 'genesis',
  completedChapters: 11,
  totalChapters: 50,
  firstMarkAt: DateTime(2026, 9, 1, 10),
  lastCompletedAt: DateTime(2026, 10, 2, 10),
);

Future<void> _pumpCard(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(child: BookStatsCard(stats: _stats)),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows the book name, the metric and the mini ring', (
    tester,
  ) async {
    await _pumpCard(tester);

    expect(find.text(AppStrings.bookName('genesis')), findsOneWidget);
    expect(find.text(AppStrings.bookProgress(11, 50, 22)), findsOneWidget);
    expect(find.byType(ProgressRing), findsOneWidget);
  });

  testWidgets('is static: no InkWell and no ripple', (tester) async {
    await _pumpCard(tester);

    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(InkResponse), findsNothing);
  });
}
