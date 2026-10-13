import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_context_menu_tokens.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/utils/word_extraction.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/check_internet_connectivity.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/highlight_color_sheet.dart';
import 'package:bibliapp/features/reading/presentation/widgets/highlight_spans.dart';
import 'package:bibliapp/features/reading/presentation/widgets/rae_webview_dialog.dart';

/// Replaces the native selection toolbar with the reading screen actions:
/// copy the word, look it up in the RAE, share the verse and underline the
/// selected range or the whole verse (spec 06 + spec 11).
class VerseContextMenu extends StatelessWidget {
  final EditableTextState editableTextState;
  final VerseEntity verse;
  final List<VerseHighlightEntity> highlights;

  const VerseContextMenu({
    super.key,
    required this.editableTextState,
    required this.verse,
    this.highlights = const [],
  });

  /// Inline highlights resolved by [HighlightSpans]; a whole-verse highlight is
  /// rendered as a container instead, so it is not part of the text layout.
  List<VerseHighlightEntity> get _inlineHighlights => highlights
      .where((highlight) => !highlight.isWholeVerse(verse.text.length))
      .toList(growable: false);

  /// Raw selected substring of the verse text, or `''` when there is none.
  String get _rawSelection {
    final range = _selectedRange;
    if (range == null) return '';
    return verse.text.substring(range.start, range.end);
  }

  /// Whether the selection is a single word, the only case where looking it up
  /// in the RAE dictionary makes sense.
  bool get _canSearchInRae => countWords(_rawSelection) == 1;

  /// Selected character range relative to the verse text. Highlighted runs are
  /// rendered as widgets, so the selection offsets are translated back through
  /// [HighlightSpans] and clamped to the text bounds.
  ({int start, int end})? get _selectedRange {
    final selection = editableTextState.textEditingValue.selection;
    if (!selection.isValid || selection.isCollapsed) return null;
    final inlineHighlights = _inlineHighlights;
    final renderedLength = HighlightSpans.renderedLength(
      text: verse.text,
      highlights: inlineHighlights,
    );
    // The rendered text is the verse-number prefix followed by the verse text,
    // where each highlighted run counts as a single placeholder character.
    final prefixLength =
        (editableTextState.textEditingValue.text.length - renderedLength).clamp(
          0,
          renderedLength,
        );
    final renderedStart = (selection.start - prefixLength).clamp(
      0,
      renderedLength,
    );
    final renderedEnd = (selection.end - prefixLength).clamp(0, renderedLength);
    final start = HighlightSpans.toTextOffset(
      text: verse.text,
      highlights: inlineHighlights,
      renderedOffset: renderedStart,
    );
    final end = HighlightSpans.toTextOffset(
      text: verse.text,
      highlights: inlineHighlights,
      renderedOffset: renderedEnd,
    );
    if (start >= end) return null;
    return (start: start, end: end);
  }

  /// The most recent highlight intersecting the current selection, if any.
  VerseHighlightEntity? get _activeHighlight {
    final range = _selectedRange;
    if (range == null) return null;
    VerseHighlightEntity? winner;
    for (final highlight in highlights) {
      final intersects =
          highlight.startOffset < range.end &&
          range.start < highlight.endOffset;
      if (!intersects) continue;
      if (winner == null || highlight.updatedAt.isAfter(winner.updatedAt)) {
        winner = highlight;
      }
    }
    return winner;
  }

  // The builder context belongs to the context menu overlay, which is removed
  // by [_dismiss]. The EditableText context stays mounted, so it is the stable
  // anchor for dialogs, the share sheet origin and the ReadingCubit lookup.
  BuildContext get _anchorContext => editableTextState.context;

  void _dismiss() => ContextMenuController.removeAny();

  Future<void> _copyWord() async {
    final text = _rawSelection.trim();
    _dismiss();
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _shareVerse() async {
    _dismiss();
    final text =
        '${verse.text} — ${AppStrings.bookName(verse.book)} '
        '${verse.chapter}:${verse.verse}';
    final box = _anchorContext.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _searchInRae() async {
    final word = extractSelectedWord(_rawSelection);
    _dismiss();
    if (word.isEmpty) return;

    final result = await getIt<CheckInternetConnectivity>()();
    final hasInternet = result.getOrElse((_) => false);
    if (!_anchorContext.mounted) return;

    if (!hasInternet) {
      await showDialog<void>(
        context: _anchorContext,
        builder: (dialogContext) => AlertDialog(
          title: const Text(AppStrings.noInternetConnection),
          content: const Text(AppStrings.needsInternetForRae),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppStrings.close),
            ),
          ],
        ),
      );
      return;
    }

    await showDialog<void>(
      context: _anchorContext,
      builder: (_) => RaeWebViewDialog(word: word),
    );
  }

  Future<void> _underlineSelection() async {
    final range = _selectedRange;
    if (range == null) return;
    await _applyUnderline(range.start, range.end);
  }

  Future<void> _underlineWholeVerse() async {
    await _applyUnderline(0, verse.text.length);
  }

  Future<void> _applyUnderline(int start, int end) async {
    _dismiss();
    final color = await HighlightColorSheet.show(_anchorContext);
    if (color == null || !_anchorContext.mounted) return;
    final now = DateTime.now();
    _anchorContext.read<ReadingCubit>().addHighlight(
      VerseHighlightEntity(
        book: verse.book,
        chapter: verse.chapter,
        verse: verse.verse,
        startOffset: start,
        endOffset: end,
        color: color,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> _changeColor() async {
    final active = _activeHighlight;
    if (active?.id == null) return;
    _dismiss();
    final color = await HighlightColorSheet.show(_anchorContext);
    if (color == null || !_anchorContext.mounted) return;
    _anchorContext.read<ReadingCubit>().changeHighlightColor(
      active!.id!,
      color,
    );
  }

  Future<void> _removeUnderline() async {
    final active = _activeHighlight;
    if (active?.id == null) return;
    _dismiss();
    _anchorContext.read<ReadingCubit>().removeHighlight(active!.id!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canEdit = _activeHighlight != null;
    final canSearchInRae = _canSearchInRae;
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          surface: AppColors.contextMenuBackground,
          onSurface: AppColors.contextMenuForeground,
        ),
      ),
      child: _GridSelectionToolbar(
        anchors: editableTextState.contextMenuAnchors,
        children: [
          if (canEdit) ...[
            _toolbarButton(
              AppStrings.changeColor,
              Icons.palette_outlined,
              _changeColor,
            ),
            _toolbarButton(
              AppStrings.removeUnderline,
              Icons.format_color_reset,
              _removeUnderline,
            ),
          ],
          _toolbarButton(AppStrings.copyWord, Icons.copy_outlined, _copyWord),
          _toolbarButton(
            AppStrings.shareVerse,
            Icons.share_outlined,
            _shareVerse,
          ),
          if (canSearchInRae)
            _toolbarButton(AppStrings.searchInRae, Icons.search, _searchInRae),
          _toolbarButton(
            AppStrings.underline,
            Icons.format_underlined,
            _underlineSelection,
          ),
          _toolbarButton(
            AppStrings.underlineVerse,
            Icons.notes,
            _underlineWholeVerse,
          ),
        ],
      ),
    );
  }

  Widget _toolbarButton(String label, IconData icon, VoidCallback onPressed) {
    return TextSelectionToolbarTextButton(
      onPressed: onPressed,
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppContextMenuTokens.iconSize),
          const SizedBox(width: AppContextMenuTokens.iconGap),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// Floating selection toolbar that keeps every action visible on narrow
/// screens: instead of the native paginated overflow menu, the actions are laid
/// out in a rectangular two-column grid that shrinks to its content instead of
/// filling the screen width.
class _GridSelectionToolbar extends StatelessWidget {
  const _GridSelectionToolbar({required this.anchors, required this.children});

  final TextSelectionToolbarAnchors anchors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const screenPadding = AppContextMenuTokens.screenPadding;
    final paddingAbove = MediaQuery.paddingOf(context).top + screenPadding;
    final anchorAbove =
        anchors.primaryAnchor - const Offset(0, AppContextMenuTokens.anchorGap);
    final anchorBelow =
        (anchors.secondaryAnchor ?? anchors.primaryAnchor) +
        const Offset(0, TextSelectionToolbar.kToolbarContentDistanceBelow);
    final localAdjustment = Offset(screenPadding, paddingAbove);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenPadding,
        paddingAbove,
        screenPadding,
        screenPadding,
      ),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchorAbove - localAdjustment,
          anchorBelow: anchorBelow - localAdjustment,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppContextMenuTokens.maxWidth,
          ),
          child: Material(
            elevation: AppContextMenuTokens.elevation,
            color: AppColors.contextMenuBackground,
            borderRadius: BorderRadius.circular(AppRadius.border),
            clipBehavior: Clip.antiAlias,
            child: IntrinsicWidth(
              child: Column(mainAxisSize: MainAxisSize.min, children: _rows()),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _rows() {
    final rows = <Widget>[];
    for (var index = 0; index < children.length; index += 2) {
      final hasSecond = index + 1 < children.length;
      rows.add(
        Row(
          children: [
            Expanded(child: children[index]),
            if (hasSecond)
              Expanded(child: children[index + 1])
            else
              const Expanded(child: SizedBox.shrink()),
          ],
        ),
      );
    }
    return rows;
  }
}
