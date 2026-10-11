import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/core/di/get_it.dart';
import 'package:bibliapp/features/reading/domain/entities/search_focus.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/pages/reading_screen.dart';
import 'package:bibliapp/features/reading/presentation/pages/search_results_screen.dart';

/// Ruta raíz: pantalla de lectura RV1960
final GoRouter appRouter = GoRouter(
  initialLocation: '/reading',
  routes: [
    GoRoute(
      path: '/reading',
      name: 'reading',
      builder: (context, state) => _blockBack(
        BlocProvider(
          create: (context) => getIt<ReadingCubit>()..initialize(),
          child: const ReadingScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/search-results',
      name: 'searchResults',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        return _blockBack(SearchResultsScreen(query: query));
      },
    ),
    GoRoute(
      path: '/reading-focus',
      name: 'readingFocus',
      builder: (context, state) {
        final params = state.uri.queryParameters;
        final focus = SearchFocus(
          book: params['book'] ?? 'genesis',
          chapter: int.tryParse(params['chapter'] ?? '') ?? 1,
          verse: int.tryParse(params['verse'] ?? '') ?? 1,
        );
        return _blockBack(
          BlocProvider(
            create: (context) => getIt<ReadingCubit>()..initialize(),
            child: ReadingScreen(focus: focus),
          ),
        );
      },
    ),
  ],
);

/// System back is disabled app-wide; navigation uses visible in-app buttons.
Widget _blockBack(Widget child) => PopScope(canPop: false, child: child);
