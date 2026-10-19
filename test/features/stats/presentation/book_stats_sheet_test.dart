import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/domain/entities/stats_entities.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_state.dart';
import 'package:bibliapp/features/stats/presentation/widgets/book_stats_sheet.dart';
import 'package:bibliapp/features/stats/presentation/widgets/chapters_line_chart.dart';
import 'package:mocktail/mocktail.dart';

class _MockStatsCubit extends MockBloc<StatsState, StatsState>
    implements StatsCubit {}

BookReadingStatsEntity _book({
  required String book,
  int completed = 11,
  int total = 50,
  DateTime? firstMarkAt,
  DateTime? lastCompletedAt,
  bool isFilled = false,
}) {
  var completedValue = completed;
  if (isFilled) completedValue = total;
  return BookReadingStatsEntity(
    book: book,
    completedChapters: completedValue,
    totalChapters: total,
    firstMarkAt: firstMarkAt,
    lastCompletedAt: lastCompletedAt,
  );
}

Future<void> _pumpSheet(WidgetTester tester, _MockStatsCubit cubit) async {
  await tester.pumpWidget(
    BlocProvider<StatsCubit>.value(
      value: cubit,
      child: const MaterialApp(home: Scaffold(body: BookStatsSheet())),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ChaptersSeriesPointEntity(date: '2026-01-01', chaptersCount: 0),
    );
    registerFallbackValue(_book(book: 'genesis', isFilled: false));
  });

  testWidgets('shows the book detail with dates and the chart', (tester) async {
    final cubit = _MockStatsCubit();
    whenListen(
      cubit,
      const Stream<StatsState>.empty(),
      initialState: StatsState(
        selectedBook: _book(
          book: 'genesis',
          firstMarkAt: DateTime(2026, 9, 1, 10),
          lastCompletedAt: DateTime(2026, 10, 2, 10),
        ),
        selectedBookSeries: const [
          ChaptersSeriesPointEntity(date: '2026-09-01', chaptersCount: 1),
        ],
      ),
    );

    await _pumpSheet(tester, cubit);

    expect(find.text('Génesis'), findsOneWidget);
    expect(find.text(AppStrings.bookProgress(11, 50, 22)), findsOneWidget);
    expect(find.text(AppStrings.statsStartDate('01/09/2026')), findsOneWidget);
    // Status and end date both read 'En curso' while the book is unfinished.
    expect(find.text(AppStrings.bookInProgress), findsExactly(2));
    expect(find.byType(ChaptersLineChart), findsOneWidget);
    expect(find.text(AppStrings.statsNoReadings), findsNothing);
  });

  testWidgets('shows Fin when the book is completed', (tester) async {
    final cubit = _MockStatsCubit();
    whenListen(
      cubit,
      const Stream<StatsState>.empty(),
      initialState: StatsState(
        selectedBook: _book(
          book: 'leviticus',
          isFilled: true,
          firstMarkAt: DateTime(2026, 9, 1, 10),
          lastCompletedAt: DateTime(2026, 10, 2, 10),
        ),
      ),
    );

    await _pumpSheet(tester, cubit);

    expect(find.text('Levítico'), findsOneWidget);
    expect(find.text(AppStrings.statsBookCompleted), findsOneWidget);
    expect(find.text(AppStrings.statsEndDate('02/10/2026')), findsOneWidget);
    expect(find.text(AppStrings.statsInCourse), findsNothing);
  });

  testWidgets('shows the no-readings message for a book without marks', (
    tester,
  ) async {
    final cubit = _MockStatsCubit();
    whenListen(
      cubit,
      const Stream<StatsState>.empty(),
      initialState: StatsState(
        selectedBook: _book(book: 'revelation', total: 22),
      ),
    );

    await _pumpSheet(tester, cubit);

    expect(find.text('Apocalipsis'), findsOneWidget);
    expect(find.text(AppStrings.statsNoReadings), findsOneWidget);
    expect(find.text(AppStrings.statsStartDate('01/09/2026')), findsNothing);
    expect(find.byType(ChaptersLineChart), findsNothing);
  });

  testWidgets('shows a loader while the detail is loading', (tester) async {
    final cubit = _MockStatsCubit();
    whenListen(
      cubit,
      const Stream<StatsState>.empty(),
      initialState: StatsState(
        selectedBook: _book(
          book: 'genesis',
          firstMarkAt: DateTime(2026, 9, 1, 10),
        ),
        isLoadingBookDetail: true,
      ),
    );

    await _pumpSheet(tester, cubit);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(ChaptersLineChart), findsNothing);
  });

  testWidgets('renders nothing without a selected book', (tester) async {
    final cubit = _MockStatsCubit();
    whenListen(
      cubit,
      const Stream<StatsState>.empty(),
      initialState: const StatsState(),
    );

    await _pumpSheet(tester, cubit);

    expect(find.byType(BookStatsSheet), findsOneWidget);
    expect(find.text('Génesis'), findsNothing);
  });
}
