import 'package:flutter/material.dart';
import 'package:bibliapp/core/router/go_router.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/data/import_rv1960.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerGetIt();
  await importRV1960(dataSource: getIt<ReadingLocalDataSource>());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bibliapp RV1960',
      theme: appTheme(),
      routerConfig: appRouter,
    );
  }
}
