import 'package:flutter/material.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/theme/highlight_palette.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';

/// Pure resolver that turns a verse text plus its inline highlights into styled
/// spans.
///
/// Overlapping highlights are resolved per character: the one with the most
/// recent [VerseHighlightEntity.updatedAt] wins. Consecutive characters sharing
/// the same winning highlight are merged into a single maximal run.
///
/// A highlighted run is rendered exactly like a whole-verse highlight (the same
/// translucent background and thin rounded border) but boxed around a word or
/// phrase. Because that box is a widget, each highlighted run occupies a single
/// placeholder character in the rendered text; [toTextOffset] and
/// [renderedLength] translate positions between the rendered text and the
/// original [text] so selection, copy and underline keep working.
class HighlightSpans {
  const HighlightSpans._();

  static List<InlineSpan> fromVerse({
    required String text,
    required List<VerseHighlightEntity> highlights,
    required TextStyle baseStyle,
  }) {
    return _resolveRuns(
      text,
      highlights,
    ).map((run) => run.toSpan(text, baseStyle)).toList(growable: false);
  }

  /// Total length of the rendered text, where every highlighted run counts as a
  /// single placeholder character.
  static int renderedLength({
    required String text,
    required List<VerseHighlightEntity> highlights,
  }) {
    return _resolveRuns(
      text,
      highlights,
    ).fold(0, (total, run) => total + run.renderedLength);
  }

  /// Maps an offset in the rendered text (see [renderedLength]) back to an
  /// offset in [text].
  static int toTextOffset({
    required String text,
    required List<VerseHighlightEntity> highlights,
    required int renderedOffset,
  }) {
    if (renderedOffset <= 0) return 0;

    int consumed = 0;
    for (final run in _resolveRuns(text, highlights)) {
      final length = run.renderedLength;
      if (renderedOffset < consumed + length) {
        return run.highlight == null
            ? run.start + (renderedOffset - consumed)
            : run.start;
      }
      if (renderedOffset == consumed + length) return run.end;
      consumed += length;
    }
    return text.length;
  }

  static List<_HighlightRun> _resolveRuns(
    String text,
    List<VerseHighlightEntity> highlights,
  ) {
    if (text.isEmpty) return const [];

    final winners = List<VerseHighlightEntity?>.filled(text.length, null);
    for (final highlight in highlights) {
      final start = highlight.startOffset.clamp(0, text.length);
      final end = highlight.endOffset.clamp(0, text.length);
      for (int index = start; index < end; index++) {
        final current = winners[index];
        if (current == null || highlight.updatedAt.isAfter(current.updatedAt)) {
          winners[index] = highlight;
        }
      }
    }

    final runs = <_HighlightRun>[];
    int runStart = 0;
    VerseHighlightEntity? runHighlight = winners[0];

    for (int index = 1; index <= text.length; index++) {
      final current = index < text.length ? winners[index] : null;
      final boundaryReached =
          index == text.length || !_sameHighlight(current, runHighlight);
      if (boundaryReached) {
        runs.add(
          _HighlightRun(start: runStart, end: index, highlight: runHighlight),
        );
        runStart = index;
        runHighlight = current;
      }
    }

    return runs;
  }

  static bool _sameHighlight(
    VerseHighlightEntity? first,
    VerseHighlightEntity? second,
  ) {
    if (identical(first, second)) return true;
    if (first == null || second == null) return false;
    return first == second;
  }
}

class _HighlightRun {
  const _HighlightRun({required this.start, required this.end, this.highlight});

  final int start;
  final int end;
  final VerseHighlightEntity? highlight;

  int get renderedLength => highlight == null ? end - start : 1;

  InlineSpan toSpan(String source, TextStyle baseStyle) {
    final runText = source.substring(start, end);
    final highlight = this.highlight;
    if (highlight == null) return TextSpan(text: runText, style: baseStyle);

    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Container(
        decoration: BoxDecoration(
          color: HighlightPalette.background(highlight.color),
          border: Border.all(
            color: HighlightPalette.base(highlight.color),
            width: HighlightPalette.borderWidth,
          ),
          borderRadius: BorderRadius.circular(AppRadius.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
        child: Text(runText, style: baseStyle),
      ),
    );
  }
}
