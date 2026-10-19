import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/theme/app_stats_tokens.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/widgets/chapters_line_chart.dart';

List<ChaptersSeriesPointEntity> _week({int count = 0}) => [
  for (var index = 0; index < 7; index++)
    ChaptersSeriesPointEntity(
      date: '2026-10-1${index + 4}',
      chaptersCount: count > index ? index + 1 : 0,
    ),
];

List<ChaptersSeriesPointEntity> _mount() => [
  for (var index = 0; index < 30; index++)
    ChaptersSeriesPointEntity(date: '2026-10-$index', chaptersCount: index % 3),
];

/// Series whose daily max reaches 10, so the Y axis must grow to 10.
List<ChaptersSeriesPointEntity> _highSeries() => [
  for (var index = 0; index < 7; index++)
    ChaptersSeriesPointEntity(
      date: '2026-10-1${index + 4}',
      chaptersCount: index == 3 ? 10 : index,
    ),
];

Future<void> _pumpChart(
  WidgetTester tester,
  List<ChaptersSeriesPointEntity> points, {
  double height = AppStatsTokens.chartHeight,
  bool disableAnimations = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: ChaptersLineChart(points: points, height: height),
            ),
          ),
        ),
      ),
    ),
  );
  if (disableAnimations) {
    await tester.pump();
  } else {
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('paints a week series without errors', (tester) async {
    await _pumpChart(tester, _week(count: 3));

    expect(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter != null,
      ),
      findsOneWidget,
    );
  });

  testWidgets('paints an empty series without crashing', (tester) async {
    await _pumpChart(tester, const []);

    expect(find.byType(ChaptersLineChart), findsOneWidget);
  });

  testWidgets('paints a 30-day month series at a narrow width', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpChart(tester, _mount());

    expect(find.byType(ChaptersLineChart), findsOneWidget);
  });

  testWidgets('paints a series whose daily max is 10', (tester) async {
    await _pumpChart(tester, _highSeries());

    expect(find.byType(ChaptersLineChart), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter != null,
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders the full chart at once with reduced motion', (
    tester,
  ) async {
    await _pumpChart(tester, _week(count: 3), disableAnimations: true);

    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    expect(find.byType(ChaptersLineChart), findsOneWidget);
  });

  testWidgets('animates the reveal through a TweenAnimationBuilder', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: ChaptersLineChart(points: _week(count: 3)),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(ChaptersLineChart), findsOneWidget);
  });

  testWidgets('uses the sheet height when one is provided', (tester) async {
    await _pumpChart(
      tester,
      _week(count: 3),
      height: AppStatsTokens.sheetChartHeight,
    );

    final chart = tester.widget<ChaptersLineChart>(
      find.byType(ChaptersLineChart),
    );
    expect(chart.height, AppStatsTokens.sheetChartHeight);
  });
}
