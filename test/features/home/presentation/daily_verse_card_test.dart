import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/home/presentation/widgets/daily_verse_card.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';

void main() {
  const dailyVerse = DailyVerseEntity(
    book: 'john',
    chapter: 3,
    verse: 16,
    text: 'Porque de tal manera amó Dios a este mundo…',
  );

  Widget buildWidget() => const MaterialApp(
    home: Scaffold(
      body: Column(children: [DailyVerseCard(dailyVerse: dailyVerse)]),
    ),
  );

  testWidgets('shows the label, the verse text and the gold reference', (
    tester,
  ) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text(AppStrings.dailyVerseLabel), findsOneWidget);
    expect(find.text(dailyVerse.text), findsOneWidget);
    expect(find.text(AppStrings.verseReference('john', 3, 16)), findsOneWidget);
  });

  testWidgets('is not tappable: it has no gesture recognizers', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(IconButton), findsNothing);
    expect(find.byIcon(Icons.ios_share), findsNothing);
  });
}
