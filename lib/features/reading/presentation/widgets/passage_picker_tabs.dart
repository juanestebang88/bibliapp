import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';

class PassagePickerTabs extends StatelessWidget {
  final PassagePickerTab selectedTab;
  final String currentBook;
  final void Function(PassagePickerTab tab) onTabSelected;

  const PassagePickerTabs({
    super.key,
    required this.selectedTab,
    required this.currentBook,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabs = <(PassagePickerTab, String)>[
      (PassagePickerTab.currentBook, AppStrings.bookName(currentBook)),
      (PassagePickerTab.oldTestament, AppStrings.oldTestament),
      (PassagePickerTab.newTestament, AppStrings.newTestament),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          for (final (tab, label) in tabs)
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  onTap: () => onTabSelected(tab),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: tab == selectedTab
                          ? theme.colorScheme.primary
                          : null,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: tab == selectedTab
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontWeight: tab == selectedTab
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
