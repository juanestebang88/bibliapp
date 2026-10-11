import 'package:equatable/equatable.dart';

/// Target verse for the reading screen pushed from search results.
class SearchFocus extends Equatable {
  final String book;
  final int chapter;
  final int verse;

  const SearchFocus({
    required this.book,
    required this.chapter,
    required this.verse,
  });

  @override
  List<Object?> get props => [book, chapter, verse];
}
