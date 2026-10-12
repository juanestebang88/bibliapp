import 'package:equatable/equatable.dart';

/// Domain entity representing the reading progress of a single chapter.
class ChapterProgressEntity extends Equatable {
  final String book;
  final int chapter;
  final int lastVerseRead;
  final bool isComplete;
  final DateTime? completedAt;

  const ChapterProgressEntity({
    required this.book,
    required this.chapter,
    required this.lastVerseRead,
    required this.isComplete,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
    book,
    chapter,
    lastVerseRead,
    isComplete,
    completedAt,
  ];
}
