import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int calls = 0;

  Future<void> pumpScroll(WidgetTester tester, {required double childHeight}) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) => calls++,
            onHorizontalDragEnd: (_) => calls += 100,
            child: SingleChildScrollView(
              child: Container(height: childHeight, color: Colors.red),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('iso 1: drag(finder) with small child (50)', (tester) async {
    await pumpScroll(tester, childHeight: 50);
    await tester.drag(find.byType(SingleChildScrollView), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'drag finder, small child');
  });

  testWidgets('iso 2: dragFrom(400,300) with small child (50)', (tester) async {
    await pumpScroll(tester, childHeight: 50);
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'dragFrom, small child');
  });

  testWidgets('iso 3: dragFrom(400,300) with tall child (2000)', (tester) async {
    await pumpScroll(tester, childHeight: 2000);
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'dragFrom, tall child');
  });

  testWidgets('iso 4: dragFrom(400,50) on small child area with small child (50)',
      (tester) async {
    await pumpScroll(tester, childHeight: 50);
    await tester.dragFrom(const Offset(400, 25), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'dragFrom on the child itself');
  });
}
