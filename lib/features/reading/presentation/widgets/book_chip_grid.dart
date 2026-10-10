import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_chip.dart';

class BookChipGrid extends StatelessWidget {
  final List<String> books;
  final String? selectedBook;
  final void Function(String book) onBookSelected;

  const BookChipGrid({
    super.key,
    required this.books,
    required this.onBookSelected,
    this.selectedBook,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: 44,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return PassagePickerChip(
          label: AppStrings.bookName(book),
          selected: book == selectedBook,
          onTap: () => onBookSelected(book),
        );
      },
    );
  }
}
