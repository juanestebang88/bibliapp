import 'package:flutter_test/flutter_test.dart';

/// Pause between visible steps so the run can be followed on the device.
/// Set to [Duration.zero] for fast runs.
const Duration kStepDelay = Duration(milliseconds: 800);

/// Pauses so each step is visible on the device. Uses a fixed pump with the
/// step delay instead of `pumpAndSettle`: the reading screen has repeating
/// animations (the progress button breathing) that never settle, so
/// `pumpAndSettle` would time out on tests that reach the last verse.
Future<void> step(WidgetTester tester) async {
  await tester.pump(kStepDelay);
  if (kStepDelay > Duration.zero) {
    await Future<void>.delayed(kStepDelay);
  }
}
