import 'package:flutter/material.dart';

class ChapterCircleButton extends StatelessWidget {
  final int chapter;
  final bool selected;
  final VoidCallback onTap;

  const ChapterCircleButton({
    super.key,
    required this.chapter,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;
    final foreground = selected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Center(
          child: Text(
            '$chapter',
            style: theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
