import 'package:flutter/material.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/chapter_verses.dart';

class VersesPage extends StatelessWidget {
  final ReadingState state;
  final List<VerseEntity> verses;

  const VersesPage({super.key, required this.state, required this.verses});

  @override
  Widget build(BuildContext context) {
    return ChapterVerses(
      state: state.copyWith(chapterVerses: verses, currentVerseNumber: 1),
      selectable: false,
    );
  }
}
