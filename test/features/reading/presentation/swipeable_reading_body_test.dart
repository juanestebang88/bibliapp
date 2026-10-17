import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_body.dart';
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
    ReadingStatus? status,
    bool emptyChapter = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(
          body: BlocProvider<ReadingCubit>.value(
            value: cubit,
            child: SwipeableReadingBody(
              state: ReadingState(
                status: status ?? ReadingStatus.success,
                chapterVerses: emptyChapter ? const [] : _sampleVerses,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('dragging left past the distance threshold loads the next '
      'chapter', (tester) async {
    await pumpBody(tester);

    await tester.drag(find.byType(SwipeableReadingBody), const Offset(-300, 0));
    await tester.pump();

    verify(() => cubit.nextChapter()).called(1);
    verifyNever(() => cubit.previousChapter());
  });

  testWidgets('dragging right past the distance threshold loads the previous '
      'chapter', (tester) async {
    await pumpBody(tester);

    await tester.drag(find.byType(SwipeableReadingBody), const Offset(300, 0));
    await tester.pump();

    verify(() => cubit.previousChapter()).called(1);
    verifyNever(() => cubit.nextChapter());
  });

  testWidgets('a fast fling triggers without reaching the distance threshold', (
    tester,
  ) async {
    await pumpBody(tester);

    await tester.fling(
      find.byType(SwipeableReadingBody),
      const Offset(-50, 0),
      2000,
    );
    await tester.pump();

    verify(() => cubit.nextChapter()).called(1);
  });

  testWidgets('a short, slow drag does not change the chapter', (tester) async {
    await pumpBody(tester);

    await tester.timedDrag(
      find.byType(SwipeableReadingBody),
      const Offset(-50, 0),
      const Duration(milliseconds: 500),
    );
    await tester.pump();

    verifyNever(() => cubit.nextChapter());
    verifyNever(() => cubit.previousChapter());
  });

  testWidgets('the gesture is ignored while the chapter is loading', (
    tester,
  ) async {
    await pumpBody(tester, status: ReadingStatus.loading);

    await tester.drag(find.byType(SwipeableReadingBody), const Offset(-300, 0));
    await tester.pump();

    verifyNever(() => cubit.nextChapter());
    verifyNever(() => cubit.previousChapter());
  });

  testWidgets('the gesture is ignored while the chapter failed to load', (
    tester,
  ) async {
    await pumpBody(tester, status: ReadingStatus.failure);

    await tester.drag(find.byType(SwipeableReadingBody), const Offset(-300, 0));
    await tester.pump();

    verifyNever(() => cubit.nextChapter());
    verifyNever(() => cubit.previousChapter());
  });

  testWidgets('the gesture is ignored on an empty chapter', (tester) async {
    await pumpBody(
      tester,
      status: ReadingStatus.success,
      emptyChapter: true,
    );

    await tester.drag(find.byType(SwipeableReadingBody), const Offset(-300, 0));
    await tester.pump();

    verifyNever(() => cubit.nextChapter());
    verifyNever(() => cubit.previousChapter());
  });

  testWidgets('renders the reading body it wraps', (tester) async {
    await pumpBody(tester);

    expect(find.byType(ReadingBody), findsOneWidget);
  });
}

class _MockReadingCubit extends Mock implements ReadingCubit {}

/// Enough verses to fill the test surface, so the drag starts over rendered
/// text like in the real app.
final List<VerseEntity> _sampleVerses = List.generate(
  40,
  (index) => VerseEntity(
    book: 'genesis',
    chapter: 1,
    verse: index + 1,
    text: 'Verse text number ${index + 1} with some length to wrap around.',
  ),
);
