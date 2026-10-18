import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
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

  testWidgets('check glyphs on read days, cross on missed days', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(const [
        ReadingDayEntity(date: '2026-10-13', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-14', chaptersCount: 1, versesCount: 5),
        ReadingDayEntity(date: '2026-10-15', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-16', chaptersCount: 1, versesCount: 7),
        ReadingDayEntity(date: '2026-10-17', chaptersCount: 0, versesCount: 0),
      ]),
    );

    final glyphs = tester
        .widgetList<Icon>(find.byType(Icon))
        .map((icon) => (icon.icon, icon.color))
        .toList();

    expect(glyphs.length, 5);
    // Past missed days (Mon, Wed): red cross; read days (Tue, Thu): check.
    expect(glyphs[0], (Icons.close, AppColors.noReadingRed));
    expect(glyphs[1], (Icons.check, AppColors.greenAccent));
    expect(glyphs[2], (Icons.close, AppColors.noReadingRed));
    expect(glyphs[3], (Icons.check, AppColors.greenAccent));
  });

  testWidgets('today without data shows a gray dash, not a cross', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(const [
        ReadingDayEntity(date: '2026-10-13', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-14', chaptersCount: 1, versesCount: 5),
        ReadingDayEntity(date: '2026-10-15', chaptersCount: 0, versesCount: 0),
        ReadingDayEntity(date: '2026-10-16', chaptersCount: 0, versesCount: 3),
        ReadingDayEntity(date: '2026-10-17', chaptersCount: 0, versesCount: 0),
      ]),
    );

    final glyphs = tester
        .widgetList<Icon>(find.byType(Icon))
        .map((icon) => (icon.icon, icon.color))
        .toList();

    expect(glyphs.last, (Icons.remove, AppColors.secondaryText));
    expect(glyphs.take(4).last, (Icons.check, AppColors.greenAccent));
  });
}
