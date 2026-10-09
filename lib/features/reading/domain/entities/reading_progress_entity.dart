import 'package:equatable/equatable.dart';

class ReadingProgressEntity extends Equatable {
  final String lastBook;
  final int lastChapter;
  final int lastVerse;
  final int timestamp;

  const ReadingProgressEntity({
    required this.lastBook,
    required this.lastChapter,
    required this.lastVerse,
    required this.timestamp,
  });

  @override
  List<Object> get props => [lastBook, lastChapter, lastVerse, timestamp];
}
