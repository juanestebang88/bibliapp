import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/widgets/bottom_toolbar.dart';

/// Section of the app currently shown, used to mark the matching toolbar item
/// as active.
enum AppSection { home, reading, stats }

/// Builds the four canonical toolbar items in a single place.
/// The item matching [current] is active, has no onTap and paints its
/// icon with AppColors.bronze. Settings is always present and inactive.
List<BottomToolbarItem> buildAppToolbarItems(
  BuildContext context, {
  required AppSection current,
}) {
  return [
    BottomToolbarItem(
      icon: Icons.home_outlined,
      label: AppStrings.home,
      onTap: current == AppSection.home ? null : () => context.go('/home'),
      isActive: current == AppSection.home,
    ),
    BottomToolbarItem(
      icon: Icons.menu_book_outlined,
      label: AppStrings.reading,
      onTap: current == AppSection.reading
          ? null
          : () => context.go('/reading'),
      isActive: current == AppSection.reading,
    ),
    BottomToolbarItem(
      icon: Icons.bar_chart,
      label: AppStrings.statistics,
      onTap: current == AppSection.stats ? null : () => context.go('/stats'),
      isActive: current == AppSection.stats,
    ),
    BottomToolbarItem(
      icon: Icons.settings_outlined,
      label: AppStrings.settings,
    ),
  ];
}
