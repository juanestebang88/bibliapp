import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  /// Font size of the passage picker (30% larger than the standard medium size)
  static const double passagePickerFontSize = 21;

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
