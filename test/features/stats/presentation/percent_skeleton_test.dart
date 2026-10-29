import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/features/stats/presentation/widgets/percent_skeleton.dart';

Widget _wrap(Widget child, {bool disableAnimations = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('renders the rounded bar with the skeleton size', (tester) async {
    await tester.pumpWidget(
      _wrap(const PercentSkeleton(), disableAnimations: true),
    );
    await tester.pump();

    final size = tester.getSize(find.byType(PercentSkeleton));
    expect(size.width, AppStatsTokens.percentSkeletonWidth);
    expect(size.height, AppStatsTokens.percentSkeletonHeight);
  });

  testWidgets('animates the shimmer while animations are enabled', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const PercentSkeleton()));
    await tester.pump();

    expect(tester.binding.transientCallbackCount, greaterThan(0));
  });

  testWidgets('paints a static bar when animations are disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const PercentSkeleton(), disableAnimations: true),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
