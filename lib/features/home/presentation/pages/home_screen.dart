import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_cubit.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_state.dart';
import 'package:bibliapp/features/home/presentation/widgets/continue_reading_card.dart';
import 'package:bibliapp/features/home/presentation/widgets/daily_verse_card.dart';
import 'package:bibliapp/features/home/presentation/widgets/home_error_view.dart';
import 'package:bibliapp/features/home/presentation/widgets/reading_days_card.dart';
import 'package:go_router/go_router.dart';

/// App start screen: daily verse, continue reading and the last 5 days.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.failure) {
              return HomeErrorView(
                message: state.errorMessage,
                onRetry: () => context.read<HomeCubit>().initialize(),
              );
            }
            if (state.status != HomeStatus.success) {
              return const Center(child: CircularProgressIndicator());
            }

            final cards = [
              if (state.dailyVerse != null)
                DailyVerseCard(dailyVerse: state.dailyVerse!),
              ContinueReadingCard(state: state),
              ReadingDaysCard(readingDays: state.readingDays),
            ];

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          for (final card in cards) ...[
                            card,
                            const SizedBox(height: AppSpacing.lg),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                BottomToolbar(
                  items: [
                    BottomToolbarItem(
                      icon: Icons.home_outlined,
                      label: AppStrings.home,
                    ),
                    BottomToolbarItem(
                      icon: Icons.menu_book_outlined,
                      label: AppStrings.reading,
                      onTap: () => context.go('/reading'),
                    ),
                    BottomToolbarItem(
                      icon: Icons.bar_chart,
                      label: AppStrings.statistics,
                    ),
                    BottomToolbarItem(
                      icon: Icons.settings_outlined,
                      label: AppStrings.settings,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
