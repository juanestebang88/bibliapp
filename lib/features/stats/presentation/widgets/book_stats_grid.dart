import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_card.dart';

/// Two-column grid of all the scoped books in canonical order. Shrink-wrapped
/// for the page's scroll view; each card is its own repaint boundary.
class BookStatsGrid extends StatelessWidget {
  final List<BookReadingStatsEntity> books;

  const BookStatsGrid({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 2.2,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookStatsCard(stats: books[index]);
      },
    );
  }
}
