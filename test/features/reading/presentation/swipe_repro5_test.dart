import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int calls = 0;

  testWidgets('min 1: translucent GestureDetector, drag outside child',
      (tester) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) => calls++,
            onHorizontalDragEnd: (_) => calls += 100,
            child: const SizedBox(height: 50),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'drag outside the child');
  });

  testWidgets('min 2: translucent GestureDetector, drag on child',
      (tester) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) => calls++,
            onHorizontalDragEnd: (_) => calls += 100,
            child: const SizedBox(height: 50),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.dragFrom(const Offset(400, 25), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'drag on the child');
  });

  testWidgets('min 3: opaque GestureDetector, drag outside child',
      (tester) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (_) => calls++,
            onHorizontalDragEnd: (_) => calls += 100,
            child: const SizedBox(height: 50),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'opaque, drag outside the child');
  });
}
