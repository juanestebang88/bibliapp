import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_circle_button.dart';

class ChapterGrid extends StatelessWidget {
  final int count;
  final int? selectedChapter;
  final void Function(int chapter) onChapterSelected;

  const ChapterGrid({
    super.key,
    required this.count,
    required this.onChapterSelected,
    this.selectedChapter,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: 44,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final chapter = index + 1;
        return ChapterCircleButton(
          chapter: chapter,
          selected: chapter == selectedChapter,
          onTap: () => onChapterSelected(chapter),
        );
      },
    );
  }
}
