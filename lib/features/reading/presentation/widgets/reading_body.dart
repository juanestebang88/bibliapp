import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_verses.dart';
import 'package:bibliapp/features/reading/presentation/widgets/failure_view.dart';

class ReadingBody extends StatelessWidget {
  final ReadingState state;

  const ReadingBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      ReadingStatus.initial ||
      ReadingStatus.loading => const Center(child: CircularProgressIndicator()),
      ReadingStatus.failure => FailureView(state: state),
      ReadingStatus.success when state.chapterVerses.isEmpty => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            AppStrings.emptyChapter,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      ReadingStatus.success => ChapterVerses(state: state),
    };
  }
}
