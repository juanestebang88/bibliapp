import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/widgets/progress_ring.dart';

void main() {
  testWidgets('renders the centered child inside the ring', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: ProgressRing(
              progress: 0.25,
              size: 120,
              strokeWidth: 10,
              child: Text('50'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ProgressRing), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
  });

  testWidgets('works without a child and clamps out-of-range progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              children: const [
                ProgressRing(progress: -1, size: 40, strokeWidth: 4),
                ProgressRing(progress: 2, size: 40, strokeWidth: 4),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ProgressRing), findsNWidgets(2));
  });
}
