import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/utils/search_text.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/search_verses.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchResult extends Equatable {
  final VerseEntity verse;
  final List<String> matchedWords;

  const SearchResult({required this.verse, required this.matchedWords});

  @override
  List<Object?> get props => [verse, matchedWords];
}

class SearchState extends Equatable {
  final SearchStatus status;
  final String query;
  final List<SearchResult> results;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<SearchResult>? results,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) => SearchState(
    status: status ?? this.status,
    query: query ?? this.query,
    results: results ?? this.results,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, query, results, errorMessage];
}

class SearchCubit extends Cubit<SearchState> {
  final SearchVerses searchVerses;

  SearchCubit({required this.searchVerses}) : super(const SearchState());

  Future<void> search(String rawQuery) async {
    final query = rawQuery.trim();
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        query: query,
        clearErrorMessage: true,
      ),
    );

    final words = searchQueryWords(query);
    if (words.isEmpty) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: AppStrings.emptyQuery,
        ),
      );
      return;
    }

    final result = await searchVerses.call(query);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (verses) => emit(
        state.copyWith(
          status: SearchStatus.success,
          results: verses
              .map(
                (verse) => SearchResult(
                  verse: verse,
                  matchedWords: _matchedWordsFor(verse.text, words),
                ),
              )
              .toList(growable: false),
          clearErrorMessage: true,
        ),
      ),
    );
  }

  List<String> _matchedWordsFor(String text, List<String> words) {
    final normalizedText = normalizeSearchText(text);
    return words
        .where((word) => containsSearchWord(normalizedText, word))
        .toList(growable: false);
  }
}
