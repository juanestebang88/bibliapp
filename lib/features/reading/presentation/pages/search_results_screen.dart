import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_spacing.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/presentation/cubit/search_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/search_result_tile.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  void _openVerse(BuildContext context, VerseEntity verse) {
    context.push(
      '/reading-focus'
      '?book=${Uri.encodeQueryComponent(verse.book)}'
      '&chapter=${verse.chapter}'
      '&verse=${verse.verse}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>()..search(query),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _ResultsHeader(resultCount: state.results.length),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    switch (state.status) {
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.failure:
        return _MessageView(
          message: state.errorMessage ?? AppStrings.noResults,
          onRetry: () => context.read<SearchCubit>().search(state.query),
        );
      case SearchStatus.initial:
      case SearchStatus.success:
        if (state.results.isEmpty) {
          return _MessageView(message: AppStrings.noResults);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: state.results.length,
          itemBuilder: (context, index) {
            final result = state.results[index];
            return SearchResultTile(
              key: ValueKey(
                '${result.verse.book}-${result.verse.chapter}-${result.verse.verse}',
              ),
              result: result,
              onTap: () => _openVerse(context, result.verse),
            );
          },
        );
    }
  }
}

class _ResultsHeader extends StatelessWidget {
  final int resultCount;

  const _ResultsHeader({required this.resultCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: AppStrings.back,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.searchResults,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  AppStrings.resultsCount(resultCount),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _MessageView({required this.message, this.onRetry});

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
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onRetry,
                child: const Text(AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
