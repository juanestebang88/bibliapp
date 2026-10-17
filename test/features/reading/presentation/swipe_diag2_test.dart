import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';

void main() {
  late _MockReadingCubit cubit;

  setUp(() {
    cubit = _MockReadingCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.nextChapter()).thenAnswer((_) async {});
    when(() => cubit.previousChapter()).thenAnswer((_) async {});
  });

  final verses = List.generate(
    40,
    (index) => VerseEntity(
      book: 'genesis',
      chapter: 1,
      verse: index + 1,
      text: 'Verse text number ${index + 1} with some length to wrap around.',
    ),
  );

  Future<void> pumpBody(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(
          body: BlocProvider<ReadingCubit>.value(
            value: cubit,
            child: SwipeableReadingBody(
              state: ReadingState(
                status: ReadingStatus.success,
                chapterVerses: verses,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('full screen: drag over text at center', (tester) async {
    await pumpBody(tester);
    await tester.drag(find.byType(SwipeableReadingBody), const Offset(-300, 0));
    await tester.pump();
    verify(() => cubit.nextChapter()).called(1);
  });

  testWidgets('full screen: drag over scroll padding at x=12', (tester) async {
    await pumpBody(tester);
    await tester.dragFrom(const Offset(12, 300), const Offset(-300, 0));
    await tester.pump();
    verify(() => cubit.nextChapter()).called(1);
  });
}

class _MockReadingCubit extends Mock implements ReadingCubit {}
