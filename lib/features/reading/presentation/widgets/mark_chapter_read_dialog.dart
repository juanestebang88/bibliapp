import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

enum MarkChapterAction { markComplete, saveUntilVerse, unmark }

class MarkChapterReadResult {
  final MarkChapterAction action;
  final int verse;

  const MarkChapterReadResult({required this.action, this.verse = 1});
}

class MarkChapterReadDialog extends StatefulWidget {
  static const double _maxWidth = 420;

  final int totalVerses;

  /// Verse selected by default in the `−/+/number` selector.
  final int initialVerse;

  /// When true the chapter is already saved as complete and only the unmark
  /// action is shown.
  final bool complete;

  const MarkChapterReadDialog({
    super.key,
    required this.totalVerses,
    required this.initialVerse,
    this.complete = false,
  });

  @override
  State<MarkChapterReadDialog> createState() => _MarkChapterReadDialogState();
}

class _MarkChapterReadDialogState extends State<MarkChapterReadDialog> {
  static const double _placeholderWidth = AppSpacing.xxl;

  late int _verse;

  @override
  void initState() {
    super.initState();
    _verse = widget.initialVerse.clamp(1, widget.totalVerses);
  }

  void _changeVerse(int delta) {
    setState(() {
      _verse = (_verse + delta).clamp(1, widget.totalVerses);
    });
  }

  void _pop(MarkChapterAction action) {
    Navigator.of(context).pop(
      MarkChapterReadResult(
        action: action,
        verse: action == MarkChapterAction.saveUntilVerse ? _verse : 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: MarkChapterReadDialog._maxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: _placeholderWidth),
                  Expanded(
                    child: Text(
                      AppStrings.chapterProgress,
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
              const SizedBox(height: AppSpacing.md),
              if (widget.complete)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.verseCount(widget.totalVerses),
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _pop(MarkChapterAction.unmark),
                        style: FilledButton.styleFrom(
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: Text(AppStrings.unmarkChapter),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.upToWhichVerse,
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StepButton(
                          icon: Icons.remove,
                          onTap: _verse > 1 ? () => _changeVerse(-1) : null,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          '$_verse',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _StepButton(
                          icon: Icons.add,
                          onTap: _verse < widget.totalVerses
                              ? () => _changeVerse(1)
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _pop(MarkChapterAction.markComplete),
                        style: FilledButton.styleFrom(
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: Text(AppStrings.markChapterComplete),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _pop(MarkChapterAction.saveUntilVerse),
                        child: Text(AppStrings.saveUpToVerse(_verse)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            icon,
            size: AppSpacing.sm,
            color: onTap == null
                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                : theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
