import 'package:equatable/equatable.dart';

/// Identifies a chapter of the Bible by its stable book id and chapter number.
class ChapterReference extends Equatable {
  final String book;
  final int chapter;

  const ChapterReference({required this.book, required this.chapter});

  @override
  List<Object> get props => [book, chapter];
}
