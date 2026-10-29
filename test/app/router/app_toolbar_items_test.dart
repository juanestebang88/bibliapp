import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/app/router/app_toolbar_items.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';
import 'package:bibliapp/core/widgets/toolbar_action.dart';

void main() {
  Widget buildApp(AppSection current) {
    final router = GoRouter(
      initialLocation: '/subject',
      routes: [
        GoRoute(
          path: '/subject',
          builder: (context, _) => Scaffold(
            body: Column(
              children: [
                const Text('subject-body'),
                BottomToolbarHost(current: current),
              ],
            ),
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (context, _) => const Scaffold(body: Text('home-body')),
        ),
        GoRoute(
          path: '/reading',
          builder: (context, _) => const Scaffold(body: Text('reading-body')),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, _) => const Scaffold(body: Text('stats-body')),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  ToolbarAction actionFor(WidgetTester tester, String label) =>
      tester.widget<ToolbarAction>(
        find.byWidgetPredicate(
          (widget) => widget is ToolbarAction && widget.label == label,
        ),
      );

  testWidgets('builds the four items in the canonical order', (tester) async {
    for (final current in AppSection.values) {
      await tester.pumpWidget(buildApp(current));
      await tester.pumpAndSettle();

      final labels = tester
          .widgetList<ToolbarAction>(find.byType(ToolbarAction))
          .map((action) => action.label)
          .toList();

      expect(labels, [
        AppStrings.home,
        AppStrings.reading,
        AppStrings.statistics,
        AppStrings.settings,
      ]);
    }
  });

  testWidgets('marks only the current section as active without onTap', (
    tester,
  ) async {
    final expected = {
      AppSection.home: AppStrings.home,
      AppSection.reading: AppStrings.reading,
      AppSection.stats: AppStrings.statistics,
    };

    for (final entry in expected.entries) {
      await tester.pumpWidget(buildApp(entry.key));
      await tester.pumpAndSettle();

      for (final action in tester.widgetList<ToolbarAction>(
        find.byType(ToolbarAction),
      )) {
        final isCurrent = action.label == entry.value;
        expect(action.isActive, isCurrent, reason: action.label);
        if (isCurrent) {
          expect(action.onTap, isNull, reason: action.label);
        }
      }
    }
  });

  testWidgets('settings is always inactive and has no action', (tester) async {
    for (final current in AppSection.values) {
      await tester.pumpWidget(buildApp(current));
      await tester.pumpAndSettle();

      final settings = actionFor(tester, AppStrings.settings);
      expect(settings.isActive, isFalse);
      expect(settings.onTap, isNull);
    }
  });

  testWidgets('from stats, Inicio navigates to /home and Lectura to /reading', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(AppSection.stats));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.home));
    await tester.pumpAndSettle();
    expect(find.text('home-body'), findsOneWidget);

    await tester.pumpWidget(buildApp(AppSection.stats));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.reading));
    await tester.pumpAndSettle();
    expect(find.text('reading-body'), findsOneWidget);
  });

  testWidgets('tapping the active item does not navigate', (tester) async {
    await tester.pumpWidget(buildApp(AppSection.home));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.home), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('subject-body'), findsOneWidget);
  });
}

class BottomToolbarHost extends StatelessWidget {
  final AppSection current;

  const BottomToolbarHost({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return BottomToolbar(
      items: buildAppToolbarItems(context, current: current),
    );
  }
}
