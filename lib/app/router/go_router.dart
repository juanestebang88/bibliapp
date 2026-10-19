import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bibliapp/app/di/get_it.dart';
import 'package:bibliapp/features/home/presentation/cubit/home_cubit.dart';
import 'package:bibliapp/features/home/presentation/pages/home_screen.dart';
import 'package:bibliapp/features/reading/domain/entities/search_focus.dart';
import 'package:bibliapp/features/reading/presentation/cubit/passage_picker_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/reading_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/search_cubit.dart';
import 'package:bibliapp/features/reading/presentation/pages/reading_screen.dart';
import 'package:bibliapp/features/reading/presentation/pages/search_results_screen.dart';
import 'package:bibliapp/features/stats/presentation/cubit/stats_cubit.dart';
import 'package:bibliapp/features/stats/presentation/pages/stats_screen.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:bibliapp/features/splash/presentation/pages/splash_screen.dart';

/// Root routes: splash → home (start) → reading and searches.
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => _blockBack(
        BlocProvider(
          create: (context) => getIt<SplashCubit>()..initialize(),
          child: const SplashScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => _blockBack(
        BlocProvider(
          create: (context) => getIt<HomeCubit>()..initialize(),
          child: const HomeScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/reading',
      name: 'reading',
      pageBuilder: (context, state) {
        final params = state.uri.queryParameters;
        final book = params['book'];
        final chapter = int.tryParse(params['chapter'] ?? '') ?? 1;
        final verse = int.tryParse(params['verse'] ?? '') ?? 1;
        // Opens the real reading at a specific location ("continue my reading
        // from here"): a fresh screen instance and cubit, no resume, so the
        // progress counter reflects this landing instead of the last session.
        final location = book == null
            ? null
            : SearchFocus(book: book, chapter: chapter, verse: verse);
        return MaterialPage(
          key: location == null
              ? const ValueKey<String>('/reading')
              : ValueKey<String>(
                  '/reading?book=$book&chapter=$chapter&verse=$verse',
                ),
          child: _blockBack(
            BlocProvider(
              create: (context) =>
                  getIt<ReadingCubit>()
                    ..initialize(applyResume: location == null),
              child: location == null
                  ? ReadingScreen(
                      createPassagePickerCubit: _createPassagePickerCubit,
                    )
                  : ReadingScreen(
                      initialLocation: location,
                      createPassagePickerCubit: _createPassagePickerCubit,
                    ),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/stats',
      name: 'stats',
      builder: (context, state) => _blockBack(
        BlocProvider(
          create: (context) => getIt<StatsCubit>()..initialize(),
          child: const StatsScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/search-results',
      name: 'searchResults',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        return _blockBack(
          BlocProvider(
            create: (_) => getIt<SearchCubit>()..search(query),
            child: SearchResultsScreen(query: query),
          ),
        );
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
            create: (context) =>
                getIt<ReadingCubit>()..initialize(applyResume: false),
            child: ReadingScreen(
              focus: focus,
              createPassagePickerCubit: _createPassagePickerCubit,
            ),
          ),
        );
      },
    ),
  ],
);

/// Fresh passage-picker cubit per dialog open (factory semantics).
PassagePickerCubit _createPassagePickerCubit() => getIt<PassagePickerCubit>();

/// System back is disabled app-wide; navigation uses visible in-app buttons.
Widget _blockBack(Widget child) => PopScope(canPop: false, child: child);
