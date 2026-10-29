import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/app/router/app_toolbar_items.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_state.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_dialog.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_grid.dart';
import 'package:bibliapp/features/stats/presentation/widgets/chapters_line_chart.dart';
import 'package:bibliapp/features/stats/presentation/widgets/chapters_today_vs_yesterday_card.dart';
import 'package:bibliapp/features/stats/presentation/widgets/duration_tile.dart';
import 'package:bibliapp/features/stats/presentation/widgets/overall_progress_card.dart';
import 'package:bibliapp/features/stats/presentation/widgets/stats_error_view.dart';
import 'package:bibliapp/features/stats/presentation/widgets/stats_period_selector.dart';
import 'package:bibliapp/features/stats/presentation/widgets/weekly_change_tile.dart';

/// Stats screen: tabs (Mi Progreso / AT / NT) recalculate the whole screen,
/// donut, quick metrics, weekly/monthly chart and the 66-book grid (spec 19).
/// StatefulWidget only for the TabController lifecycle, no business logic.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: StatsTab.values.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final tab = StatsTab.values[_tabController.index];
    if (tab == context.read<StatsCubit>().state.selectedTab) return;
    context.read<StatsCubit>().selectTab(tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, state) {
            if (state.status == StatsStatus.failure) {
              return StatsErrorView(
                message: state.errorMessage,
                onRetry: () => context.read<StatsCubit>().retry(),
              );
            }

            return Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: state.status != StatsStatus.success
                      ? const Center(child: CircularProgressIndicator())
                      : _buildContent(context, state),
                ),
                _buildToolbar(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(AppStrings.statsTitle, style: theme.textTheme.titleLarge),
          SizedBox(
            width: double.infinity,
            child: TabBar(
              controller: _tabController,
              dividerColor: theme.colorScheme.surface,
              indicatorColor: AppColors.goldAccent,
              labelColor: AppColors.goldAccent,
              unselectedLabelColor: AppColors.secondaryText,
              labelStyle: theme.textTheme.labelSmall,
              tabs: const [
                Tab(text: AppStrings.tabMyProgress),
                Tab(text: AppStrings.tabOldTestament),
                Tab(text: AppStrings.tabNewTestament),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, StatsState state) {
    final theme = Theme.of(context);
    final chartTitle = state.selectedPeriod == StatsPeriod.week
        ? AppStrings.readingsPerWeek
        : AppStrings.readingsPerMonth;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          OverallProgressCard(overview: state.overview),
          const SizedBox(height: AppSpacing.xl),
          ChaptersTodayVsYesterdayCard(overview: state.overview),
          const SizedBox(height: AppSpacing.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: DurationTile(overview: state.overview)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: WeeklyChangeTile(overview: state.overview)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(chartTitle, style: theme.textTheme.titleMedium),
              ),
              StatsPeriodSelector(
                selected: state.selectedPeriod,
                onSelected: context.read<StatsCubit>().selectPeriod,
              ),
            ],
          ),
          Text(
            AppStrings.chaptersPerDayUnit,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ChaptersLineChart(points: state.series),
          const SizedBox(height: AppSpacing.xl),
          BookStatsGrid(
            books: state.visibleBooks,
            onBookTap: (book) async {
              final cubit = context.read<StatsCubit>();
              cubit.openBook(book);
              await showBookStatsDialog(context);
              cubit.closeBook();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return BottomToolbar(
      items: buildAppToolbarItems(context, current: AppSection.stats),
    );
  }
}
