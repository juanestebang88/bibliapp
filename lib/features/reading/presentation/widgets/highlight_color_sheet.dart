import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/highlight_palette.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';

/// Bottom sheet that lets the reader pick one of the four highlight colors.
///
/// Pops with the selected [HighlightColor], or `null` when dismissed.
class HighlightColorSheet extends StatelessWidget {
  static const double _swatchSize = 44;

  const HighlightColorSheet({super.key});

  static Future<HighlightColor?> show(BuildContext context) {
    final theme = Theme.of(context);
    return showModalBottomSheet<HighlightColor>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.border),
        ),
      ),
      builder: (_) => const HighlightColorSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.chooseColor,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final color in HighlightPalette.ordered)
                  _ColorOption(
                    color: color,
                    size: _swatchSize,
                    onTap: () => Navigator.of(context).pop(color),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final HighlightColor color;
  final double size;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.size,
    required this.onTap,
  });

  String get _label => switch (color) {
    HighlightColor.green => AppStrings.colorGreen,
    HighlightColor.blue => AppStrings.colorBlue,
    HighlightColor.yellow => AppStrings.colorYellow,
    HighlightColor.copper => AppStrings.colorCopper,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: _label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: HighlightPalette.base(color),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(_label, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
