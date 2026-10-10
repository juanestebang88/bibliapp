import 'package:equatable/equatable.dart';

class ReadingProgressEntity extends Equatable {
  final String lastBook;
  final int lastChapter;

  const ReadingProgressEntity({
    required this.lastBook,
    required this.lastChapter,
  });

  @override
  List<Object> get props => [lastBook, lastChapter];
}
