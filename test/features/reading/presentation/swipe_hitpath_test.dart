import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hit path: GestureDetector > Center > Text at (12,300)',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) {},
            child: const Center(child: Text('hello')),
          ),
        ),
      ),
    );
    await tester.pump();
    final result = HitTestResult();
    tester.binding.hitTestInView(result, const Offset(12, 300), tester.view.viewId);
    final types = result.path.map((e) => e.target.runtimeType.toString()).toList();
    expect(types, isEmpty, reason: 'path: $types');
  });

  testWidgets('hit path: GestureDetector > SizedBox(50) at (400,300)',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) {},
            child: const SizedBox(height: 50),
          ),
        ),
      ),
    );
    await tester.pump();
    final result = HitTestResult();
    tester.binding.hitTestInView(result, const Offset(400, 300), tester.view.viewId);
    final types = result.path.map((e) => e.target.runtimeType.toString()).toList();
    expect(types, isEmpty, reason: 'path: $types');
  });
}
