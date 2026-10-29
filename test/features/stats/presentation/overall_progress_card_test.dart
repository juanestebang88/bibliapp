import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/widgets/progress_ring.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/widgets/overall_progress_card.dart';
import 'package:bibliapp/features/stats/presentation/widgets/percent_skeleton.dart';

void main() {
  testWidgets('shows the scope percent with one decimal inside the ring', (
    tester,
  ) async {
    // 11 of 1189 chapters = 0.9%.
    const overview = ReadingOverviewEntity(
      completedChapters: 11,
      totalChapters: 1189,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: OverallProgressCard(overview: overview)),
        ),
      ),
    );

    expect(
      find.text(AppStrings.percentOneDecimal(overview.overallProgress * 100)),
      findsOneWidget,
    );
    expect(find.byType(ProgressRing), findsOneWidget);
    expect(find.byType(PercentSkeleton), findsNothing);
  });

  testWidgets('renders 0.0% when nothing has been marked yet', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: OverallProgressCard(overview: ReadingOverviewEntity()),
          ),
        ),
      ),
    );

    expect(find.text(AppStrings.percentOneDecimal(0)), findsOneWidget);
  });

  testWidgets('replaces the percent with the skeleton while switching tabs', (
    tester,
  ) async {
    const overview = ReadingOverviewEntity(
      completedChapters: 11,
      totalChapters: 1189,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: OverallProgressCard(
              overview: overview,
              isSwitchingTab: true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PercentSkeleton), findsOneWidget);
    expect(
      find.text(AppStrings.percentOneDecimal(overview.overallProgress * 100)),
      findsNothing,
    );
    expect(find.byType(ProgressRing), findsOneWidget);
  });
}
