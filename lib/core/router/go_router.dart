import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/features/reading/presentation/pages/reading_screen.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';

/// Ruta raíz: pantalla de lectura RV1960
final GoRouter appRouter = GoRouter(
  initialLocation: '/reading',
  routes: [
    GoRoute(
      path: '/reading',
      name: 'reading',
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<ReadingCubit>()..initialize(),
        child: const ReadingScreen(),
      ),
    ),
  ],
);
