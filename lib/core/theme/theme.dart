import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData appTheme({Brightness brightness = Brightness.dark}) {
  final isDark = brightness == Brightness.dark;
  final background = isDark
      ? AppColors.appBackground
      : AppColors.lightBackground;
  final surface = isDark ? AppColors.elevatedSurface : AppColors.lightSurface;
  final foreground = isDark ? AppColors.offWhite : AppColors.darkText;

  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0,
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.googleSansFlex(
        color: foreground,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.googleSansFlex(
        color: foreground,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.googleSansFlex(
        color: foreground,
        fontSize: 20,
        height: 1.7,
      ),
      labelSmall: GoogleFonts.googleSansFlex(color: foreground, fontSize: 12),
    ),
    colorScheme:
        (isDark
                ? ColorScheme.dark(
                    primary: AppColors.goldAccent,
                    secondary: AppColors.bronze,
                    surface: surface,
                    onSurface: foreground,
                  )
                : ColorScheme.light(
                    primary: AppColors.goldAccent,
                    secondary: AppColors.bronze,
                    surface: surface,
                    onSurface: foreground,
                  ))
            .copyWith(
              onPrimary: isDark ? AppColors.darkText : AppColors.lightSurface,
            ),
  );
}
