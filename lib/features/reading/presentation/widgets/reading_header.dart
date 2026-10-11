import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/app_text_styles.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

class ReadingHeader extends StatelessWidget {
  final ReadingState state;
  final VoidCallback onOpenPicker;
  final VoidCallback onSearch;

  const ReadingHeader({
    super.key,
    required this.state,
    required this.onOpenPicker,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<ReadingCubit>();
    final passage =
        '${AppStrings.bookName(state.currentBook)} ${state.currentChapter}';

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Material(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    onTap: onOpenPicker,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              passage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: AppTextStyles.passagePickerFontSize,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Material(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  onTap: onSearch,
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: state.fontSize <= 14
                    ? null
                    : () => cubit.adjustFontSize(-1),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(AppSpacing.xl, AppSpacing.xl),
                  padding: EdgeInsets.zero,
                ),
                child: Text('A−', style: AppTextStyles.labelAMinus),
              ),
              TextButton(
                onPressed: state.fontSize >= 32
                    ? null
                    : () => cubit.adjustFontSize(1),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(AppSpacing.xl, AppSpacing.xl),
                  padding: EdgeInsets.zero,
                ),
                child: Text('A+', style: AppTextStyles.labelAPlus),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
