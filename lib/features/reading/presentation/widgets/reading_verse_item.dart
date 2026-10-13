import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/highlight_palette.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/presentation/widgets/highlight_spans.dart';
import 'package:bibliapp/features/reading/presentation/widgets/verse_context_menu.dart';

class ReadingVerseItem extends StatelessWidget {
  static const double _highlightOpacity = 0.22;

  final VerseEntity verse;
  final double fontSize;
  final Animation<double>? highlight;
  final List<VerseHighlightEntity> highlights;

  const ReadingVerseItem({
    super.key,
    required this.verse,
    required this.fontSize,
    this.highlight,
    this.highlights = const [],
  });

  /// The most recent highlight that spans the whole verse text, rendered as a
  /// bordered container instead of inline spans.
  VerseHighlightEntity? get _wholeVerseHighlight {
    VerseHighlightEntity? winner;
    for (final highlight in highlights) {
      if (!highlight.isWholeVerse(verse.text.length)) continue;
      if (winner == null || highlight.updatedAt.isAfter(winner.updatedAt)) {
        winner = highlight;
      }
    }
    return winner;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.primary,
      fontSize: fontSize,
    );
    final textStyle = theme.textTheme.bodyLarge?.copyWith(fontSize: fontSize);

    final wholeVerseHighlight = _wholeVerseHighlight;
    final inlineHighlights = highlights
        .where((highlight) => !identical(highlight, wholeVerseHighlight))
        .toList();

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(text: '${verse.verse} ', style: numberStyle),
            ...HighlightSpans.fromVerse(
              text: verse.text,
              highlights: inlineHighlights,
              baseStyle: textStyle ?? const TextStyle(),
            ),
          ],
        ),
        contextMenuBuilder: (context, editableTextState) => VerseContextMenu(
          editableTextState: editableTextState,
          verse: verse,
          highlights: highlights,
        ),
      ),
    );

    final decorated = wholeVerseHighlight == null
        ? content
        : Container(
            decoration: BoxDecoration(
              color: HighlightPalette.background(wholeVerseHighlight.color),
              border: Border.all(
                color: HighlightPalette.base(wholeVerseHighlight.color),
                width: HighlightPalette.borderWidth,
              ),
              borderRadius: BorderRadius.circular(AppRadius.border),
            ),
            child: content,
          );

    final animation = highlight;
    if (animation == null) return decorated;

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
      child: decorated,
    );
  }
}
