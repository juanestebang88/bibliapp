import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/widgets/passage_picker_chip.dart';

class NumberChipGrid extends StatelessWidget {
  final int count;
  final int? selectedNumber;
  final void Function(int number) onNumberSelected;

  const NumberChipGrid({
    super.key,
    required this.count,
    required this.onNumberSelected,
    this.selectedNumber,
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
        final number = index + 1;
        return PassagePickerChip(
          label: '$number',
          selected: number == selectedNumber,
          onTap: () => onNumberSelected(number),
        );
      },
    );
  }
}
