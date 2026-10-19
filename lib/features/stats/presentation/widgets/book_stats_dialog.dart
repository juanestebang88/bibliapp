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

/// Opens the per-book detail dialog centered over the stats screen (spec 20).
/// Modal routes live above the page's BlocProvider, so the cubit is
/// re-provided for the dialog subtree.
Future<void> showBookStatsDialog(BuildContext context) {
  final cubit = context.read<StatsCubit>();
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider<StatsCubit>.value(
      value: cubit,
      child: const BookStatsDialog(),
    ),
  );
}

/// Detail of one book: name, reading status, metric, start/end dates and the
/// book's own chapters-per-day chart. Books never marked show 'Sin iniciar'
/// and 'Sin lecturas registradas' instead of dates and chart.
class BookStatsDialog extends StatelessWidget {
  const BookStatsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        final book = state.selectedBook;
        if (book == null) return const SizedBox.shrink();

        return Dialog(
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
                  _statusLabel(book.status),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.bookProgress(
                    book.completedChapters,
                    book.totalChapters,
                    (book.progress * 100).round(),
                  ),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                ..._dateLines(book, theme),
                const SizedBox(height: AppSpacing.lg),
                _detail(context, state, book),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(AppStrings.statsPopupClose),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _statusLabel(BookReadingStatus status) => switch (status) {
    BookReadingStatus.notStarted => AppStrings.statsNotStarted,
    BookReadingStatus.inProgress => AppStrings.bookInProgress,
    BookReadingStatus.completed => AppStrings.statsCompleted,
  };

  /// 'Inicio: dd/mm/yyyy' once the book has a first mark; 'Fin: dd/mm/yyyy'
  /// only when it is completed.
  List<Widget> _dateLines(BookReadingStatsEntity book, ThemeData theme) {
    final lines = <Widget>[];
    if (book.status != BookReadingStatus.notStarted &&
        book.firstMarkAt != null) {
      lines.add(
        Text(
          AppStrings.statsStartDate(localDateDisplay(book.firstMarkAt!)),
          style: theme.textTheme.labelMedium,
        ),
      );
    }
    if (book.status == BookReadingStatus.completed &&
        book.lastCompletedAt != null) {
      if (lines.isNotEmpty) lines.add(const SizedBox(height: AppSpacing.xs));
      lines.add(
        Text(
          AppStrings.statsEndDate(localDateDisplay(book.lastCompletedAt!)),
          style: theme.textTheme.labelMedium,
        ),
      );
    }
    return lines;
  }

  Widget _detail(
    BuildContext context,
    StatsState state,
    BookReadingStatsEntity book,
  ) {
    final theme = Theme.of(context);
    if (state.isLoadingBookDetail) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (book.status == BookReadingStatus.notStarted) {
      return Text(
        AppStrings.statsNoReadings,
        style: theme.textTheme.labelMedium,
      );
    }
    return SizedBox(
      height: AppStatsTokens.sheetChartHeight,
      width: double.infinity,
      child: ChaptersLineChart(points: state.selectedBookSeries),
    );
  }
}
