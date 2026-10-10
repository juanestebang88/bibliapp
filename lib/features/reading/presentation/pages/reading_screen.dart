import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_navigation.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_dialog.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_header.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  Future<void> _openPassagePicker(
    BuildContext context,
    ReadingState state,
  ) async {
    final cubit = context.read<ReadingCubit>();
    final selection = await showDialog<PassageSelection>(
      context: context,
      builder: (_) => PassagePickerDialog(
        currentBook: state.currentBook,
        currentChapter: state.currentChapter,
        currentVerseNumber: state.currentVerseNumber,
      ),
    );
    if (selection == null) return;
    await cubit.loadChapterAndScrollTo(
      selection.reference.book,
      selection.reference.chapter,
      selection.verse,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReadingCubit, ReadingState>(
        builder: (context, state) => SafeArea(
          child: Column(
            children: [
              ReadingHeader(
                state: state,
                onOpenPicker: () => _openPassagePicker(context, state),
              ),
              Expanded(child: SwipeableReadingBody(state: state)),
              const SizedBox(height: AppSpacing.sm),
              ChapterNavigation(state: state),
              const BottomToolbar(
                items: [
                  BottomToolbarItem(
                    icon: Icons.home_outlined,
                    label: AppStrings.home,
                  ),
                  BottomToolbarItem(
                    icon: Icons.menu_book_outlined,
                    label: AppStrings.reading,
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
          ),
        ),
      ),
    );
  }
}
