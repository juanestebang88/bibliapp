import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

class FailureView extends StatelessWidget {
  final ReadingState state;

  const FailureView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? AppStrings.emptyChapter,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.read<ReadingCubit>().loadChapter(
                state.currentBook,
                state.currentChapter,
              ),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
