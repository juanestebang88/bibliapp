import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/utils/word_extraction.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/check_internet_connectivity.dart';
import 'package:bibliapp/features/reading/presentation/widgets/rae_webview_dialog.dart';

/// Replaces the native selection toolbar with the three actions of the reading
/// screen: copy the word, look it up in the RAE and share the verse.
class VerseContextMenu extends StatelessWidget {
  final EditableTextState editableTextState;
  final VerseEntity verse;

  const VerseContextMenu({
    super.key,
    required this.editableTextState,
    required this.verse,
  });

  String get _selectedWord {
    final value = editableTextState.textEditingValue;
    if (!value.selection.isValid || value.selection.isCollapsed) return '';
    return extractSelectedWord(value.selection.textInside(value.text));
  }

  // The builder context belongs to the context menu overlay, which is removed
  // by [_dismiss]. The EditableText context stays mounted, so it is the stable
  // anchor for dialogs and for the share sheet origin.
  BuildContext get _anchorContext => editableTextState.context;

  void _dismiss() => ContextMenuController.removeAny();

  Future<void> _copyWord() async {
    _dismiss();
    final word = _selectedWord;
    if (word.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: word));
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
    _dismiss();
    final word = _selectedWord;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          surface: AppColors.contextMenuBackground,
          onSurface: AppColors.contextMenuForeground,
        ),
      ),
      child: AdaptiveTextSelectionToolbar.buttonItems(
        anchors: editableTextState.contextMenuAnchors,
        buttonItems: [
          ContextMenuButtonItem(
            label: AppStrings.copyWord,
            onPressed: _copyWord,
          ),
          ContextMenuButtonItem(
            label: AppStrings.shareVerse,
            onPressed: _shareVerse,
          ),
          ContextMenuButtonItem(
            label: AppStrings.searchInRae,
            onPressed: _searchInRae,
          ),
        ],
      ),
    );
  }
}
