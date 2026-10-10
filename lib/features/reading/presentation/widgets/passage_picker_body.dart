import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/book_order.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_reference.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/book_chip_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_grid.dart';
import 'package:bibliapp/features/reading/presentation/widgets/number_chip_grid.dart';

class PassagePickerBody extends StatelessWidget {
  const PassagePickerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PassagePickerCubit, PassagePickerState>(
      builder: (context, state) {
        if (state.status == PassagePickerStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == PassagePickerStatus.failure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                state.errorMessage ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        final cubit = context.read<PassagePickerCubit>();
        return switch (state.level) {
          PassagePickerLevel.books => BookChipGrid(
            books: state.tab == PassagePickerTab.oldTestament
                ? oldTestamentBooks
                : newTestamentBooks,
            selectedBook: state.currentBook,
            onBookSelected: cubit.selectBook,
          ),
          PassagePickerLevel.chapters =>
            state.tab == PassagePickerTab.currentBook
                ? ChapterGrid(
                    count: state.chapterCount,
                    selectedChapter: state.currentChapter,
                    onChapterSelected: cubit.selectChapter,
                  )
                : NumberChipGrid(
                    count: state.chapterCount,
                    onNumberSelected: cubit.selectChapter,
                  ),
          PassagePickerLevel.verses => NumberChipGrid(
            count: state.verseCount,
            selectedNumber:
                state.selectedChapter == state.currentChapter &&
                    (state.selectedBook ?? state.currentBook) ==
                        state.currentBook
                ? state.currentVerseNumber
                : null,
            onNumberSelected: (verse) {
              final reference = ChapterReference(
                book: state.selectedBook ?? state.currentBook,
                chapter: state.selectedChapter ?? state.currentChapter,
              );
              Navigator.of(context).pop((reference: reference, verse: verse));
            },
          ),
        };
      },
    );
  }
}
