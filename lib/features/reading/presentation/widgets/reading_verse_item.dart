import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';

class ReadingVerseItem extends StatelessWidget {
  static const double _highlightOpacity = 0.22;

  final VerseEntity verse;
  final double fontSize;
  final bool isCurrent;
  final bool selectable;
  final VoidCallback onTap;
  final Animation<double>? highlight;

  const ReadingVerseItem({
    super.key,
    required this.verse,
    required this.fontSize,
    required this.onTap,
    this.isCurrent = false,
    this.selectable = true,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.primary,
      fontSize: fontSize,
      fontWeight: isCurrent ? FontWeight.bold : null,
    );
    final textStyle = theme.textTheme.bodyLarge?.copyWith(fontSize: fontSize);

    final content = InkWell(
      borderRadius: BorderRadius.circular(AppRadius.border),
      onTap: selectable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${verse.verse} ', style: numberStyle),
              TextSpan(text: verse.text, style: textStyle),
            ],
          ),
        ),
      ),
    );

    final animation = highlight;
    if (animation == null) return content;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          color: AppColors.goldAccent.withValues(
            alpha: animation.value * _highlightOpacity,
          ),
          borderRadius: BorderRadius.circular(AppRadius.border),
        ),
        child: child,
      ),
      child: content,
    );
  }
}
