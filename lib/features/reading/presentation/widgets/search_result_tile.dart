import 'package:flutter/material.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/core/utils/search_text.dart';
import 'package:bibliapp/features/reading/presentation/cubit/search_cubit.dart';

class SearchResultTile extends StatelessWidget {
  final SearchResult result;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title =
        '${AppStrings.bookName(result.verse.book)} '
        '${result.verse.chapter}:${result.verse.verse}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text.rich(_fullTextSpan(), style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _fullTextSpan() {
    final ranges = _mergeRanges(result);
    if (ranges.isEmpty) {
      return TextSpan(text: result.verse.text);
    }
    return TextSpan(children: _underlinedSpans(ranges));
  }

  List<TextSpan> _underlinedSpans(List<WordRange> ranges) {
    const highlightStyle = TextStyle(
      backgroundColor: AppColors.goldAccent,
      color: AppColors.darkText,
    );
    final text = result.verse.text;
    final sorted = [...ranges]..sort((a, b) => a.start.compareTo(b.start));
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final range in sorted) {
      if (range.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, range.start)));
      }
      spans.add(
        TextSpan(
          text: text.substring(range.start, range.end),
          style: highlightStyle,
        ),
      );
      cursor = range.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return spans;
  }

  List<WordRange> _mergeRanges(SearchResult result) {
    final seen = <WordRange>{};
    final ranges = <WordRange>[];
    for (final word in result.matchedWords) {
      for (final range in searchWordRanges(result.verse.text, word)) {
        if (seen.add(range)) ranges.add(range);
      }
    }
    return ranges;
  }
}
