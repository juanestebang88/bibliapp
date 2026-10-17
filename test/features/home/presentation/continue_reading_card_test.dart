import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_state.dart';
import 'package:bibliapp/features/home/presentation/widgets/continue_reading_card.dart';
import 'package:bibliapp/features/reading/domain/entities/continue_reading_entity.dart';
import 'package:go_router/go_router.dart';

HomeState _state({
  String book = 'genesis',
  int chapter = 3,
  int? lastVerseRead,
  int completed = 2,
  int chapterCount = 50,
}) => HomeState(
  status: HomeStatus.success,
  continueLocation: ContinueReadingEntity(
    book: book,
    chapter: chapter,
    lastVerseRead: lastVerseRead,
  ),
  continueBook: book,
  chaptersCompleted: completed,
  chapterCount: chapterCount,
);

Widget _buildApp({required HomeState homeState}) => MaterialApp.router(
  routerConfig: GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, _) =>
            Scaffold(body: ContinueReadingCard(state: homeState)),
      ),
      GoRoute(
        path: '/reading',
        builder: (context, routeState) =>
            Scaffold(body: Text('reading-target: ${routeState.uri}')),
      ),
    ],
  ),
);

Future<void> _tapContinue(WidgetTester tester) async {
  await tester.tap(find.text(AppStrings.continueReading));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows book and chapter plus the "N of M read" summary', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(homeState: _state()));

    expect(
      find.text(AppStrings.readingLocationTitle('genesis', 3)),
      findsOneWidget,
    );
    expect(find.text(AppStrings.chaptersReadSummary(2, 50)), findsOneWidget);
  });

  testWidgets('shows the plural remaining-chapters text', (tester) async {
    await tester.pumpWidget(_buildApp(homeState: _state()));

    expect(
      find.text(
        AppStrings.remainingChapters(48, AppStrings.bookName('genesis')),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows the singular remaining text when K = 1', (tester) async {
    await tester.pumpWidget(_buildApp(homeState: _state(completed: 49)));

    expect(
      find.text(
        AppStrings.remainingChapters(1, AppStrings.bookName('genesis')),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows the completed text when the book is done', (tester) async {
    await tester.pumpWidget(_buildApp(homeState: _state(completed: 50)));

    expect(
      find.text(AppStrings.bookCompleted(AppStrings.bookName('genesis'))),
      findsOneWidget,
    );
    expect(find.text(AppStrings.continueReading), findsOneWidget);
  });

  testWidgets('the continue button opens the chapter after the last '
      'completed one', (tester) async {
    await tester.pumpWidget(_buildApp(homeState: _state()));
    await _tapContinue(tester);

    expect(
      find.text('reading-target: /reading?book=genesis&chapter=3'),
      findsOneWidget,
    );
  });

  testWidgets('the continue button opens the partial chapter resuming at '
      'its verse', (tester) async {
    await tester.pumpWidget(_buildApp(homeState: _state(lastVerseRead: 12)));
    await _tapContinue(tester);

    expect(
      find.textContaining(
        'reading-target: /reading?book=genesis&chapter=3&verse=12',
      ),
      findsOneWidget,
    );
  });

  testWidgets('when the book is completed the button resumes the plain '
      'reading', (tester) async {
    await tester.pumpWidget(_buildApp(homeState: _state(completed: 50)));
    await _tapContinue(tester);

    expect(find.text('reading-target: /reading'), findsOneWidget);
  });
}
