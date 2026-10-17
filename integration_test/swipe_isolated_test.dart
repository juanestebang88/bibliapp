import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_verse_item.dart';
import 'package:bibliapp/features/reading/presentation/widgets/swipeable_reading_body.dart';
import 'package:bibliapp/main.dart';
import 'package:bibliapp/core/router/go_router.dart' as app_router;

import 'helpers/step_delay.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    registerGetIt();
  });

  setUp(() async {
    final db = getIt<ReadingDatabase>();
    await db.delete(db.readingProgress).go();
    await db.delete(db.chapterProgress).go();
  });

  final Finder body = find.byType(SwipeableReadingBody);

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

  Future<void> pumpReadingScreen(WidgetTester tester) async {
    app_router.appRouter.go('/reading');
    await tester.pumpWidget(const MyApp());
    await waitUntilFound(tester, find.byType(ReadingVerseItem));
    await step(tester);
  }

  testWidgets('isolated AC-1 flow: swipe left loads Genesis 2',
      (tester) async {
    await pumpReadingScreen(tester);
    final distance = tester.getSize(body).width * 0.4;

    await tester.drag(body, Offset(-distance, 0));
    await waitUntilFound(tester, find.text('Génesis 2'));
    await step(tester);
    expect(find.text('Génesis 2'), findsOneWidget);
  });
}
