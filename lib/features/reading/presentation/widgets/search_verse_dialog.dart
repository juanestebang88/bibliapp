import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_radius.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';

class SearchVerseDialog extends StatefulWidget {
  const SearchVerseDialog({super.key});

  static const double _maxWidth = 420;

  @override
  State<SearchVerseDialog> createState() => _SearchVerseDialogState();
}

class _SearchVerseDialogState extends State<SearchVerseDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    Navigator.of(context).pop(query);
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
          maxWidth: SearchVerseDialog._maxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: AppSpacing.xxl),
                  Expanded(
                    child: Text(
                      AppStrings.search,
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
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\n')),
                ],
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: Text(AppStrings.search),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
