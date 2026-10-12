import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_verses.dart';
import 'package:bibliapp/features/reading/presentation/widgets/failure_view.dart';

class ReadingBody extends StatelessWidget {
  final ReadingState state;

  /// Reports the last verse number visible inside the viewport.
  final ValueChanged<int>? onVisibleVerseChanged;

  /// Extra trailing room in the scrollable content, used to keep the last
  /// verse clear of the floating progress button.
  final double bottomContentInset;

  const ReadingBody({
    super.key,
    required this.state,
    this.onVisibleVerseChanged,
    this.bottomContentInset = 0,
  });

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
      ReadingStatus.success => ChapterVerses(
        state: state,
        onVisibleVerseChanged: onVisibleVerseChanged,
        bottomContentInset: bottomContentInset,
      ),
    };
  }
}
