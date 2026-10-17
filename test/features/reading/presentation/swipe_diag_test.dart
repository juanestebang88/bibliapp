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

  Future<void> pumpBody(
    WidgetTester tester, {
    required List<VerseEntity> verses,
  }) async {
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

  testWidgets('diag A: empty verses, dragFrom at (12,300)', (tester) async {
    await pumpBody(tester, verses: const []);
    await tester.dragFrom(const Offset(12, 300), const Offset(-300, 0));
    await tester.pump();
    verify(() => cubit.nextChapter()).called(1);
  });

  testWidgets('diag B: one verse, dragFrom at (12,300)', (tester) async {
    await pumpBody(
      tester,
      verses: const [
        VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Sample'),
      ],
    );
    await tester.dragFrom(const Offset(12, 300), const Offset(-300, 0));
    await tester.pump();
    verify(() => cubit.nextChapter()).called(1);
  });

  testWidgets('diag C: one verse, manual gesture with pumps', (tester) async {
    await pumpBody(
      tester,
      verses: const [
        VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Sample'),
      ],
    );
    final gesture = await tester.startGesture(const Offset(12, 300));
    await tester.pump();
    await gesture.moveBy(const Offset(-100, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-200, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump();
    verify(() => cubit.nextChapter()).called(1);
  });

  testWidgets('diag D: one verse, dragFrom at (400,300) center', (tester) async {
    await pumpBody(
      tester,
      verses: const [
        VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Sample'),
      ],
    );
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    verify(() => cubit.nextChapter()).called(1);
  });
}

class _MockReadingCubit extends Mock implements ReadingCubit {}
