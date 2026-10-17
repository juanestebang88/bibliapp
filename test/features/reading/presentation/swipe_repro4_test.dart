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

  testWidgets('measure: size and center of the scroll view', (tester) async {
    await pumpScroll(tester, childHeight: 50);
    expect(tester.getSize(find.byType(SingleChildScrollView)), const Size(800, 600));
    expect(tester.getCenter(find.byType(SingleChildScrollView)), const Offset(400, 300));
  });

  testWidgets('same point: drag(finder) vs dragFrom', (tester) async {
    await pumpScroll(tester, childHeight: 50);
    // drag(finder) resolves to the center of the scroll view.
    await tester.drag(find.byType(SingleChildScrollView), const Offset(-300, 0));
    await tester.pump();
    final dragFinderCalls = calls;
    expect(dragFinderCalls, greaterThan(0), reason: 'drag(finder) should work');
  });

  testWidgets('same point via dragFrom with explicit center', (tester) async {
    await pumpScroll(tester, childHeight: 50);
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0), reason: 'dragFrom at the same center should work');
  });
}
