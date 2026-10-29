import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bibliapp/core/theme/app_motion.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/widgets/reading_immersive_scaffold.dart';

void main() {
  const headerKey = Key('test-header');
  const footerKey = Key('test-footer');
  const accessoryKey = Key('test-accessory');

  test('chrome reappears after 900 ms and animates in 250 ms', () {
    expect(AppMotion.chromeIdleDelay, const Duration(milliseconds: 900));
    expect(AppMotion.chromeDuration, const Duration(milliseconds: 250));
  });

  Widget buildListView() => ListView.builder(
    itemCount: 100,
    itemExtent: 48,
    itemBuilder: (context, index) => Text('row $index'),
  );

  Widget buildSubject({
    required ReadingState state,
    Widget? body,
    Widget? topAccessory,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ReadingImmersiveScaffold(
          state: state,
          header: const SizedBox(
            key: headerKey,
            height: 60,
            child: Text('HEADER'),
          ),
          topAccessory: topAccessory,
          body: body ?? buildListView(),
          footer: const SizedBox(
            key: footerKey,
            height: 80,
            child: Text('FOOTER'),
          ),
        ),
      ),
    );
  }

  double topOf(WidgetTester tester, Key key) =>
      tester.getTopLeft(find.byKey(key)).dy;

  Future<void> pumpSubject(
    WidgetTester tester, {
    ReadingState? state,
    Widget? body,
    Widget? topAccessory,
  }) async {
    await tester.pumpWidget(
      buildSubject(
        state: state ?? const ReadingState(status: ReadingStatus.success),
        body: body,
        topAccessory: topAccessory,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('hides chrome on scroll and shows it after the idle delay', (
    tester,
  ) async {
    await pumpSubject(tester);
    final initialHeader = topOf(tester, headerKey);
    final initialFooter = topOf(tester, footerKey);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(topOf(tester, headerKey), lessThan(initialHeader));
    expect(topOf(tester, footerKey), greaterThan(initialFooter));

    await tester.pump(AppMotion.chromeIdleDelay);
    await tester.pumpAndSettle();

    expect(topOf(tester, headerKey), closeTo(initialHeader, 0.1));
    expect(topOf(tester, footerKey), closeTo(initialFooter, 0.1));
  });

  testWidgets('does not hide chrome below the scroll threshold', (
    tester,
  ) async {
    await pumpSubject(tester);
    final initialHeader = topOf(tester, headerKey);

    await tester.drag(find.byType(ListView), const Offset(0, -20));
    await tester.pumpAndSettle();

    expect(topOf(tester, headerKey), closeTo(initialHeader, 0.1));
  });

  testWidgets('shows chrome immediately when reaching the top end', (
    tester,
  ) async {
    await pumpSubject(tester);
    final initialHeader = topOf(tester, headerKey);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), lessThan(initialHeader));

    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();

    expect(topOf(tester, headerKey), closeTo(initialHeader, 0.1));
  });

  testWidgets('shows chrome immediately on tap', (tester) async {
    await pumpSubject(tester);
    final initialHeader = topOf(tester, headerKey);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), lessThan(initialHeader));

    await tester.tap(find.byType(ListView));
    await tester.pumpAndSettle();

    expect(topOf(tester, headerKey), closeTo(initialHeader, 0.1));
  });

  testWidgets('keeps chrome visible while loading', (tester) async {
    await pumpSubject(
      tester,
      state: const ReadingState(status: ReadingStatus.loading),
      body: const Center(child: Text('loading')),
    );

    expect(topOf(tester, headerKey), closeTo(0, 0.1));
    expect(find.text('FOOTER'), findsOneWidget);
  });

  testWidgets('expands the reading area to full height while hidden', (
    tester,
  ) async {
    const bodyKey = Key('test-body');
    await pumpSubject(
      tester,
      body: KeyedSubtree(key: bodyKey, child: buildListView()),
    );
    final visibleHeight = tester.getSize(find.byKey(bodyKey)).height;

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    final hiddenHeight = tester.getSize(find.byKey(bodyKey)).height;
    expect(hiddenHeight, greaterThan(visibleHeight));
  });

  testWidgets('never hides the top accessory', (tester) async {
    await pumpSubject(
      tester,
      topAccessory: const SizedBox(
        key: accessoryKey,
        height: 32,
        child: Text('ACCESSORY'),
      ),
    );
    final initialAccessory = topOf(tester, accessoryKey);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(topOf(tester, accessoryKey), closeTo(initialAccessory, 0.1));
  });

  testWidgets('keeps row position stable when chrome reappears mid-chapter', (
    tester,
  ) async {
    await pumpSubject(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), lessThan(0));

    final rowTop = tester.getRect(find.text('row 10')).top;

    await tester.pump(AppMotion.chromeIdleDelay);
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), closeTo(0, 0.1));

    final rowTopAfter = tester.getRect(find.text('row 10')).top;
    expect(rowTopAfter, closeTo(rowTop, 1.0));
  });

  testWidgets('moves content only by the user scroll when chrome hides', (
    tester,
  ) async {
    await pumpSubject(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.pump(AppMotion.chromeIdleDelay);
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), closeTo(0, 0.1));

    final rowTop = tester.getRect(find.text('row 10')).top;

    await tester.drag(find.byType(ListView), const Offset(0, -50));
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), lessThan(0));

    final rowShift = rowTop - tester.getRect(find.text('row 10')).top;
    expect(rowShift, greaterThan(0));
    // A 50px drag scrolls ~30px after touch slop. Without anchoring the row
    // would additionally jump by the 60px top inset.
    expect(rowShift, lessThan(60));
  });

  testWidgets('keeps content stable at the chapter bottom', (tester) async {
    await pumpSubject(tester);
    final position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;

    await tester.drag(find.byType(ListView), const Offset(0, -10000));
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), closeTo(0, 0.1));
    expect(position.pixels, lessThanOrEqualTo(position.maxScrollExtent));

    await tester.drag(find.byType(ListView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), lessThan(0));
    final pixelsAfterHide = position.pixels;

    await tester.pump(AppMotion.chromeIdleDelay);
    await tester.pumpAndSettle();

    expect(topOf(tester, headerKey), closeTo(0, 0.1));
    // Compensation pulls the content back toward the bottom but is clamped
    // at the scroll boundary (accepted residual movement at the extremes).
    expect(position.pixels, greaterThan(pixelsAfterHide));
    expect(position.pixels, lessThanOrEqualTo(position.maxScrollExtent));
  });

  testWidgets('resets to visible when the chapter changes', (tester) async {
    await pumpSubject(tester);
    final initialHeader = topOf(tester, headerKey);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(topOf(tester, headerKey), lessThan(initialHeader));

    await pumpSubject(
      tester,
      state: const ReadingState(
        status: ReadingStatus.success,
        currentChapter: 2,
      ),
    );

    expect(topOf(tester, headerKey), closeTo(initialHeader, 0.1));
  });
}
