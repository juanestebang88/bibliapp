import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  /// Font size of the passage picker (30% larger than the standard medium size)
  static const double passagePickerFontSize = 21;

  /// Main centered title in bold (used for the chapter title)
  static final TextStyle chapterTitle = GoogleFonts.googleSansFlex(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Main verse text
  static final TextStyle verseText = GoogleFonts.googleSansFlex(
    fontSize: 20,
    color: Colors.black87,
    height: 1.5,
  );

  /// Verse number text in superscript (gold color)
  static final TextStyle verseNumber = GoogleFonts.googleSansFlex(
    fontSize: 12,
    color: Color(0xFFD4A853),
    fontStyle: FontStyle.italic,
  );

  /// Reduced font size text (A-)
  static final TextStyle textSizeReduced = GoogleFonts.googleSansFlex(
    fontSize: 16,
    color: Colors.black87,
  );

  /// Increased font size text (A+)
  static final TextStyle textSizeIncreased = GoogleFonts.googleSansFlex(
    fontSize: 24,
    color: Colors.black87,
  );

  /// Small action button
  static final TextStyle buttonSmall = GoogleFonts.googleSansFlex(
    fontSize: 12,
    color: Colors.white,
  );

  /// A- button label (gold, enlarged)
  static final TextStyle labelAMinus = GoogleFonts.googleSansFlex(
    fontSize: 22,
    color: AppColors.goldAccent,
  );

  /// A+ button label (gold, enlarged)
  static final TextStyle labelAPlus = GoogleFonts.googleSansFlex(
    fontSize: 22,
    color: AppColors.goldAccent,
  );
}
