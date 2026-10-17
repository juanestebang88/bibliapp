import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int calls = 0;

  Future<void> pump(
    WidgetTester tester,
    Widget child,
  ) async {
    calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (_) => calls++,
            onHorizontalDragEnd: (_) => calls += 100,
            child: child,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('repro 1: GestureDetector > SingleChildScrollView > Text',
      (tester) async {
    await pump(
      tester,
      SingleChildScrollView(
        child: Column(
          children: [const Text('hello')],
        ),
      ),
    );
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0));
  });

  testWidgets('repro 2: GestureDetector > SingleChildScrollView > SelectableText',
      (tester) async {
    await pump(
      tester,
      SingleChildScrollView(
        child: Column(
          children: [const SelectableText('hello')],
        ),
      ),
    );
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0));
  });

  testWidgets('repro 3: GestureDetector > SelectableText only', (tester) async {
    await pump(tester, const SelectableText('hello'));
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0));
  });

  testWidgets('repro 4: GestureDetector > SingleChildScrollView only',
      (tester) async {
    await pump(
      tester,
      SingleChildScrollView(child: Container(height: 50)),
    );
    await tester.dragFrom(const Offset(400, 300), const Offset(-300, 0));
    await tester.pump();
    expect(calls, greaterThan(0));
  });
}
