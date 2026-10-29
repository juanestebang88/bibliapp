import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';

void main() {
  Widget wrap(List<BottomToolbarItem> items) => MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: BottomToolbar(items: items),
      ),
    ),
  );

  testWidgets('renders the provided items', (tester) async {
    await tester.pumpWidget(
      wrap(const [
        BottomToolbarItem(icon: Icons.home_outlined, label: 'Inicio'),
        BottomToolbarItem(icon: Icons.menu_book_outlined, label: 'Lectura'),
        BottomToolbarItem(icon: Icons.bar_chart, label: 'Estadísticas'),
        BottomToolbarItem(icon: Icons.settings_outlined, label: 'Ajustes'),
      ]),
    );

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Lectura'), findsOneWidget);
    expect(find.text('Estadísticas'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
  });

  testWidgets('fires onTap when an item is tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap([
        BottomToolbarItem(
          icon: Icons.home_outlined,
          label: 'Inicio',
          onTap: () => tapped = true,
        ),
      ]),
    );

    await tester.tap(find.text('Inicio'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('paints the active icon in bronze and keeps the label style', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const [
        BottomToolbarItem(
          icon: Icons.home_outlined,
          label: 'Inicio',
          isActive: true,
        ),
        BottomToolbarItem(icon: Icons.menu_book_outlined, label: 'Lectura'),
      ]),
    );

    final context = tester.element(find.byType(BottomToolbar));
    final activeIcon = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
    final inactiveIcon = tester.widget<Icon>(
      find.byIcon(Icons.menu_book_outlined),
    );
    final label = tester.widget<Text>(find.text('Inicio'));

    expect(activeIcon.color, AppColors.bronze);
    expect(inactiveIcon.color, Theme.of(context).colorScheme.primary);
    expect(
      label.style?.color,
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
    );
  });

  testWidgets('the active item shows no InkWell even with an onTap', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        BottomToolbarItem(
          icon: Icons.home_outlined,
          label: 'Inicio',
          isActive: true,
          onTap: () {},
        ),
      ]),
    );

    expect(find.byType(InkWell), findsNothing);
  });
}
