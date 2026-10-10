import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

class PassagePickerHeader extends StatelessWidget {
  final bool canGoBack;
  final VoidCallback onBack;

  const PassagePickerHeader({
    super.key,
    required this.canGoBack,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (canGoBack)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: AppStrings.back,
              onPressed: onBack,
            )
          else
            const SizedBox(width: AppSpacing.xxl + AppSpacing.sm),
          Expanded(
            child: Text(
              AppStrings.selectPassage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: AppStrings.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
