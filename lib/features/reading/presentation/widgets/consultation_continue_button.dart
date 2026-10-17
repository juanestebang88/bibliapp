import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

/// The single full-width green pill at the bottom of a consultation reading
/// screen. It leaves the search session behind and opens the real reading
/// screen exactly at the verse and chapter the user was consulting.
class ConsultationContinueButton extends StatelessWidget {
  /// Location this button continues from (the passage currently on screen).
  final String book;
  final int chapter;
  final int verse;

  /// Only navigates once the chapter is loaded and available.
  final bool enabled;

  const ConsultationContinueButton({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.pill);
    final background = enabled
        ? AppColors.highlightCopper
        : AppColors.pillBackground;
    final foreground = enabled ? AppColors.darkText : AppColors.offWhite;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Tooltip(
        message: AppStrings.continueFromHere,
        child: Material(
          color: background,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: enabled
                ? () => context.go(
                    '/reading'
                    '?book=${Uri.encodeQueryComponent(book)}'
                    '&chapter=$chapter&verse=$verse',
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: foreground,
                    size: AppSpacing.xl,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      AppStrings.continueFromHere,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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
        ),
      ),
    );
  }
}
