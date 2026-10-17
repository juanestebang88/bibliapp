import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/home/presentation/widgets/reading_days_card.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';

Widget _buildApp(List<ReadingDayEntity> readingDays) => MaterialApp(
  home: Scaffold(body: ReadingDaysCard(readingDays: readingDays)),
);

void main() {
  testWidgets('shows "Hoy" last and the short day names in order', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(const [
        ReadingDayEntity(date: '2026-10-13', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-14', chaptersCount: 1, versesCount: 5),
        ReadingDayEntity(date: '2026-10-15', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-16', chaptersCount: 1, versesCount: 9),
        ReadingDayEntity(date: '2026-10-17', chaptersCount: 0, versesCount: 0),
      ]),
    );

    // Tuesday Oct 13 2026 → 'Lun'. Today (Oct 17) shows the special label.
    expect(find.text(AppStrings.shortDayName(2)), findsOneWidget);
    expect(find.text(AppStrings.shortDayName(3)), findsOneWidget);
    expect(find.text(AppStrings.shortDayName(4)), findsOneWidget);
    expect(find.text(AppStrings.shortDayName(5)), findsOneWidget);
    expect(find.text(AppStrings.today), findsOneWidget);
  });

  testWidgets('days with activity show green dots, inactive gray', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(const [
        ReadingDayEntity(date: '2026-10-13', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-14', chaptersCount: 1, versesCount: 5),
        ReadingDayEntity(date: '2026-10-15', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-16', chaptersCount: 0, versesCount: 7),
        ReadingDayEntity(date: '2026-10-17', chaptersCount: 0, versesCount: 0),
      ]),
    );

    final dots = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .where(
          (d) =>
              d.decoration is BoxDecoration &&
              (d.decoration as BoxDecoration).shape == BoxShape.circle,
        )
        .map((d) => (d.decoration as BoxDecoration).color)
        .toList();

    expect(dots.length, 5);
    expect(dots[0], dots[2]);
    expect(dots[0], dots[4]);
    expect(dots[1], dots[3]);
    expect(dots[1], isNot(dots[0]));
  });
}
