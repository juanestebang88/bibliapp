import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/presentation/widgets/verse_context_menu.dart';

class ReadingVerseItem extends StatelessWidget {
  static const double _highlightOpacity = 0.22;

  final VerseEntity verse;
  final double fontSize;
  final Animation<double>? highlight;

  const ReadingVerseItem({
    super.key,
    required this.verse,
    required this.fontSize,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.primary,
      fontSize: fontSize,
    );
    final textStyle = theme.textTheme.bodyLarge?.copyWith(fontSize: fontSize);

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(text: '${verse.verse} ', style: numberStyle),
            TextSpan(text: verse.text, style: textStyle),
          ],
        ),
        contextMenuBuilder: (context, editableTextState) => VerseContextMenu(
          editableTextState: editableTextState,
          verse: verse,
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
