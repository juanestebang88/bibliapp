import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

/// Action pills shown on the reading screen opened from search results:
/// the white pill returns to the results list and the green pill leaves the
/// search session entirely, going back to the root reading screen that keeps
/// the user's own reading position.
class ReadingFocusActions extends StatelessWidget {
  /// Whether the white "back to results" pill is rendered. It remains visible
  /// while the search focus is active for the loaded passage; the green pill
  /// is always visible while the screen is a consultation screen.
  final bool showBackToResults;

  const ReadingFocusActions({super.key, required this.showBackToResults});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBackToResults) ...[
              Flexible(
                child: _ReadingFocusPill(
                  background: AppColors.lightSurface,
                  foreground: AppColors.darkText,
                  icon: Icons.arrow_back,
                  label: AppStrings.backToResults,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: _ReadingFocusPill(
                background: AppColors.greenAccent,
                foreground: AppColors.darkText,
                icon: Icons.menu_book_outlined,
                label: AppStrings.backToMyReading,
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingFocusPill extends StatelessWidget {
  final Color background;
  final Color foreground;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ReadingFocusPill({
    required this.background,
    required this.foreground,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.pill);

    return Material(
      color: background,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foreground, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
