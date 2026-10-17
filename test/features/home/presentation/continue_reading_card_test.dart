import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_state.dart';
import 'package:bibliapp/features/home/presentation/widgets/continue_reading_card.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:go_router/go_router.dart';

HomeState _state({
  String book = 'genesis',
  int chapter = 3,
  int completed = 2,
  int chapterCount = 50,
}) => HomeState(
  status: HomeStatus.success,
  lastLocation: ReadingProgressEntity(lastBook: book, lastChapter: chapter),
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
        builder: (context, state) => const Scaffold(body: Text('reading-body')),
      ),
    ],
  ),
);

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

  testWidgets('the continue button navigates to /reading on tap', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(homeState: _state()));
    await tester.tap(find.text(AppStrings.continueReading));
    await tester.pumpAndSettle();

    expect(find.text('reading-body'), findsOneWidget);
  });
}
