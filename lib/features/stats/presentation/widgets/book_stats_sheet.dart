import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/core/utils/local_date_key.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_state.dart';
import 'package:bibliapp/features/stats/presentation/widgets/chapters_line_chart.dart';

/// Opens the per-book detail bottom sheet over the stats screen (spec 19).
/// Modal routes live above the page's BlocProvider, so the cubit is
/// re-provided for the sheet subtree.
Future<void> showBookStatsSheet(BuildContext context) {
  final cubit = context.read<StatsCubit>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    builder: (_) => BlocProvider<StatsCubit>.value(
      value: cubit,
      child: const BookStatsSheet(),
    ),
  );
}

/// Detail of one book: name, completion state, metric, start/end dates and
/// the book's own chapters-per-day chart. Books without marks show
/// 'Sin lecturas registradas' instead of the chart.
class BookStatsSheet extends StatelessWidget {
  const BookStatsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        final book = state.selectedBook;
        if (book == null) return const SizedBox.shrink();

        final percent = (book.progress * 100).round();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.bookName(book.book),
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  book.isCompleted
                      ? AppStrings.statsBookCompleted
                      : AppStrings.bookInProgress,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.bookProgress(
                    book.completedChapters,
                    book.totalChapters,
                    percent,
                  ),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                if (book.firstMarkAt != null)
                  Text(
                    AppStrings.statsStartDate(
                      localDateDisplay(book.firstMarkAt!),
                    ),
                    style: theme.textTheme.labelMedium,
                  ),
                const SizedBox(height: AppSpacing.xs),
                _endLabel(context, book),
                const SizedBox(height: AppSpacing.lg),
                if (state.isLoadingBookDetail)
                  const Center(child: CircularProgressIndicator())
                else if (book.firstMarkAt == null)
                  Text(
                    AppStrings.statsNoReadings,
                    style: theme.textTheme.labelMedium,
                  )
                else
                  SizedBox(
                    height: AppStatsTokens.sheetChartHeight,
                    width: double.infinity,
                    child: ChaptersLineChart(points: state.selectedBookSeries),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 'Fin: dd/mm/yyyy' once completed; 'En curso' while the book is not
  /// finished (or was finished today).
  Widget _endLabel(BuildContext context, BookReadingStatsEntity book) {
    final theme = Theme.of(context);
    final finishedBeforeToday =
        book.isCompleted &&
        book.lastCompletedAt != null &&
        _isBeforeToday(book.lastCompletedAt!);
    return Text(
      finishedBeforeToday
          ? AppStrings.statsEndDate(localDateDisplay(book.lastCompletedAt!))
          : AppStrings.statsInCourse,
      style: theme.textTheme.labelMedium,
    );
  }

  bool _isBeforeToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }
}
