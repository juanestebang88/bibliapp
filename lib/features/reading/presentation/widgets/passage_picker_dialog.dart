import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_reference.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_body.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_header.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_tabs.dart';

typedef PassageSelection = ({ChapterReference reference, int verse});

class PassagePickerDialog extends StatelessWidget {
  static const double _maxWidth = 420;
  static const double _maxHeightFactor = 0.7;

  final String currentBook;
  final int currentChapter;
  final int currentVerseNumber;

  const PassagePickerDialog({
    super.key,
    required this.currentBook,
    required this.currentChapter,
    required this.currentVerseNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PassagePickerCubit>()
        ..initialize(
          currentBook: currentBook,
          currentChapter: currentChapter,
          currentVerseNumber: currentVerseNumber,
        ),
      child: BlocBuilder<PassagePickerCubit, PassagePickerState>(
        builder: (context, state) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _maxWidth,
              maxHeight: MediaQuery.of(context).size.height * _maxHeightFactor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PassagePickerHeader(
                  canGoBack: state.canGoBack,
                  onBack: () => context.read<PassagePickerCubit>().goBack(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: PassagePickerTabs(
                    selectedTab: state.tab,
                    currentBook: state.currentBook,
                    onTabSelected: (tab) =>
                        context.read<PassagePickerCubit>().selectTab(tab),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: const PassagePickerBody(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
