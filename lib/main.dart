import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bibliapp/app/router/go_router.dart';
import 'package:bibliapp/app/di/get_it.dart';
import 'package:bibliapp/core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _preloadAppFonts();
  registerGetIt();
  runApp(const MyApp());
}

Future<void> _preloadAppFonts() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  for (final weight in const [
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
  ]) {
    GoogleFonts.googleSansFlex(fontWeight: weight);
  }
  await GoogleFonts.pendingFonts();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bibliapp RV1960',
      theme: appTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
