import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int calls = 0;

  testWidgets('repro 5: PageView > ListView, horizontal drag', (tester) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: PageView(
          onPageChanged: (_) => calls++,
          children: [
            ListView(children: [const Text('page 1')]),
            const Text('page 2'),
          ],
        ),
      ),
    );
    await tester.pump();
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pump();
    expect(calls, 1);
  });

  testWidgets('repro 6: GestureDetector > ListView, horizontal drag',
      (tester) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) => calls++,
            onHorizontalDragEnd: (_) => calls += 100,
            child: ListView(children: [const Text('hello')]),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0));
  });

  testWidgets('repro 7: GestureDetector > SingleChildScrollView, drag on child',
      (tester) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) => calls++,
            onHorizontalDragEnd: (_) => calls += 100,
            child: SingleChildScrollView(
              child: Container(height: 2000, color: Colors.red),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.drag(find.byType(SingleChildScrollView), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0));
  });
}
