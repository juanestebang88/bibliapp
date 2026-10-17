import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/router/go_router.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/pages/reading_screen.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_verse_item.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';
import 'package:bibliapp/main.dart';

import 'helpers/step_delay.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    registerGetIt();
  });

  setUp(() async {
    // Start every test from a clean reading state so the app resumes at
    // Genesis 1 instead of the last chapter read in a previous session.
    final db = getIt<ReadingDatabase>();
    await db.delete(db.readingProgress).go();
    await db.delete(db.chapterProgress).go();
  });

  final Finder body = find.byType(SwipeableReadingBody);

  /// Pumps frames until [finder] finds at least one widget, or fails after
  /// [timeout]. Real async work (local DB queries) completes between pumps.
  Future<void> waitUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for $finder');
  }

  /// Boots the real app straight into /reading and waits until the chapter
  /// content (verse items) is rendered, i.e. ReadingStatus.success.
  Future<void> pumpReadingScreen(WidgetTester tester) async {
    appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await waitUntilFound(tester, find.byType(ReadingVerseItem));
    await step(tester);
  }

  double dragDistancePastThreshold(WidgetTester tester) {
    // 40% of the body width, comfortably above the 25% threshold.
    return tester.getSize(body).width * 0.4;
  }

  testWidgets('AC-1: swiping left loads the next chapter and swiping right '
      'the previous one', (tester) async {
    await pumpReadingScreen(tester);
    final distance = dragDistancePastThreshold(tester);

    await tester.drag(body, Offset(-distance, 0));
    await waitUntilFound(tester, find.text('Génesis 2'));
    await step(tester);
    expect(find.text('Génesis 2'), findsOneWidget);

    await tester.drag(body, Offset(distance, 0));
    await waitUntilFound(tester, find.text('Génesis 1'));
    await step(tester);
    expect(find.text('Génesis 1'), findsOneWidget);
  });

  testWidgets('AC-2: a fast fling changes the chapter without reaching the '
      'distance threshold', (tester) async {
    await pumpReadingScreen(tester);
    // 10% of the width: below the 25% threshold, so only the fling velocity
    // can trigger the navigation.
    final shortDistance = tester.getSize(body).width * 0.10;

    await tester.fling(body, Offset(-shortDistance, 0), 3000);
    await waitUntilFound(tester, find.text('Génesis 2'));
    await step(tester);
    expect(find.text('Génesis 2'), findsOneWidget);
  });

  testWidgets('AC-3: a short, slow drag does not change the chapter',
      (tester) async {
    await pumpReadingScreen(tester);
    // 15% of the width over 600 ms: below both the distance threshold and
    // the fling velocity threshold.
    final shortDistance = tester.getSize(body).width * 0.15;

    await tester.timedDrag(
      body,
      Offset(-shortDistance, 0),
      const Duration(milliseconds: 600),
    );
    await step(tester);
    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.text('Génesis 2'), findsNothing);
  });

  testWidgets('AC-4: the swipe gesture does not interfere with vertical '
      'scroll or long-press verse selection', (tester) async {
    await pumpReadingScreen(tester);
    final screenContext = tester.element(find.byType(ReadingScreen));
    final firstVerseText =
        screenContext.read<ReadingCubit>().state.chapterVerses.first.text;
    final firstVerse = find.textContaining(firstVerseText);
    expect(firstVerse, findsOneWidget);

    // Vertical scroll moves through the chapter without changing it.
    await tester.timedDrag(
      body,
      const Offset(0, -600),
      const Duration(milliseconds: 400),
    );
    await step(tester);
    expect(firstVerse, findsNothing);
    expect(find.text('Génesis 1'), findsOneWidget);

    // Scroll back to the top and long-press the verse: the context menu
    // (verse selection) must still appear.
    await tester.timedDrag(
      body,
      const Offset(0, 600),
      const Duration(milliseconds: 400),
    );
    await waitUntilFound(tester, firstVerse);
    await step(tester);

    await tester.longPress(firstVerse);
    await step(tester);
    expect(find.text(AppStrings.underlineVerse), findsOneWidget);
  });

  testWidgets('AC-6: nothing happens swiping back on Genesis 1 or forward on '
      'the last chapter', (tester) async {
    await pumpReadingScreen(tester);
    final distance = dragDistancePastThreshold(tester);

    await tester.drag(body, Offset(distance, 0));
    await step(tester);
    expect(find.text('Génesis 1'), findsOneWidget);
    expect(find.text('Génesis 2'), findsNothing);

    // Test arrangement: jump to the last chapter of the Bible through the
    // cubit so the swipe-at-the-boundary behavior can be exercised.
    final screenContext = tester.element(find.byType(ReadingScreen));
    await screenContext.read<ReadingCubit>().loadChapter('revelation', 22);
    await waitUntilFound(tester, find.text('Apocalipsis 22'));
    await step(tester);

    await tester.drag(body, Offset(-distance, 0));
    await step(tester);
    expect(find.text('Apocalipsis 22'), findsOneWidget);
  });

  testWidgets('AC-7: the chapter change via swipe shows the chrome again, '
      'like the navigation buttons do', (tester) async {
    await pumpReadingScreen(tester);

    // Scroll down mid-chapter so the immersive chrome hides.
    await tester.timedDrag(
      body,
      const Offset(0, -400),
      const Duration(milliseconds: 400),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      tester.getTopLeft(find.text('Génesis 1')).dy,
      lessThan(0),
      reason: 'the header should be hidden after scrolling down',
    );

    // Swiping left changes the chapter and the chrome reappears.
    final distance = dragDistancePastThreshold(tester);
    await tester.drag(body, Offset(-distance, 0));
    await waitUntilFound(tester, find.text('Génesis 2'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      tester.getTopLeft(find.text('Génesis 2')).dy,
      greaterThanOrEqualTo(0),
      reason: 'the header should be visible again after the chapter change',
    );
  });

  testWidgets('AC-8: the swipe also works on the /reading-focus route',
      (tester) async {
    appRouter.go('/reading-focus?book=genesis&chapter=1&verse=1');
    await tester.pumpWidget(const MyApp());
    await waitUntilFound(tester, find.byType(ReadingVerseItem));
    await step(tester);
    expect(find.text('Génesis 1'), findsOneWidget);

    final distance = dragDistancePastThreshold(tester);
    await tester.drag(body, Offset(-distance, 0));
    await waitUntilFound(tester, find.text('Génesis 2'));
    await step(tester);
    expect(find.text('Génesis 2'), findsOneWidget);
  });
}
