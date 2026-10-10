import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_reference.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_nav_button.dart';

class ChapterNavigation extends StatelessWidget {
  final ReadingState state;

  const ChapterNavigation({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingCubit>();
    final canNavigate = state.status == ReadingStatus.success;
    final previousReference = state.previousChapterReference;
    final nextReference = state.nextChapterReference;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: ChapterNavButton(
              icon: Icons.arrow_back_ios,
              label: previousReference == null
                  ? AppStrings.previous
                  : _referenceLabel(previousReference),
              enabled: canNavigate && previousReference != null,
              tooltip: AppStrings.previousChapter,
              onTap: cubit.previousChapter,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ChapterNavButton(
              icon: Icons.arrow_forward_ios,
              label: nextReference == null
                  ? AppStrings.next
                  : _referenceLabel(nextReference),
              enabled: canNavigate && nextReference != null,
              tooltip: AppStrings.nextChapter,
              iconLeading: false,
              onTap: cubit.nextChapter,
            ),
          ),
        ],
      ),
    );
  }

  String _referenceLabel(ChapterReference reference) {
    if (reference.book == state.currentBook) {
      return AppStrings.chapter(reference.chapter);
    }
    return '${AppStrings.bookName(reference.book)} ${reference.chapter}';
  }
}
