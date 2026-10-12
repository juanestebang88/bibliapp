class AppSplashTokens {
  const AppSplashTokens._();

  /// Rendered size of the splash logo. Matches the native splash, which draws
  /// `logo-splash.png` (1024px, sized for 4x density) at 256dp.
  static const double logoSize = 256;

  /// Breathing pulse of the splash logo: starts at 1, grows to 1.03 and fades
  /// to 0.72 opacity before returning.
  static const double breathScale = 1.03;
  static const double breathOpacity = 0.72;

  /// Width and thickness of the loading bar under the splash logo.
  static const double progressWidth = 140;
  static const double progressThickness = 3;
}
