import 'package:bibliapp/core/bootstrap/bible_bootstrap.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/core/theme/app_colors.dart';
import 'package:bibliapp/core/theme/theme.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:bibliapp/features/splash/presentation/pages/splash_screen.dart';
import 'package:bibliapp/features/splash/presentation/widgets/splash_error_view.dart';
import 'package:bibliapp/features/splash/presentation/widgets/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockBibleBootstrap extends Mock implements BibleBootstrap {}

void main() {
  late _MockBibleBootstrap bibleBootstrap;

  setUp(() {
    bibleBootstrap = _MockBibleBootstrap();
  });

  Widget buildApp(SplashCubit cubit) {
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
        GoRoute(
          path: '/reading',
          builder: (_, _) => const Scaffold(body: Text('reading-placeholder')),
        ),
      ],
    );
    return BlocProvider<SplashCubit>.value(
      value: cubit,
      child: MaterialApp.router(theme: appTheme(), routerConfig: router),
    );
  }

  testWidgets('shows the breathing logo and loading bar while loading', (
    tester,
  ) async {
    final cubit = SplashCubit(bibleBootstrap: bibleBootstrap);
    await tester.pumpWidget(buildApp(cubit));

    expect(find.byType(SplashLogo), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.splashBackground);

    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });

  testWidgets('shows an error with retry when the import fails', (
    tester,
  ) async {
    when(() => bibleBootstrap.ensureImported()).thenAnswer(
      (_) async => Left<Failure, Unit>(const DatabaseFailure('boom')),
    );
    final cubit = SplashCubit(bibleBootstrap: bibleBootstrap);
    await tester.pumpWidget(buildApp(cubit));

    cubit.initialize();
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.byType(SplashErrorView), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });

  testWidgets('retry recovers and navigates to reading', (tester) async {
    var calls = 0;
    when(() => bibleBootstrap.ensureImported()).thenAnswer((_) async {
      calls++;
      return calls == 1
          ? Left<Failure, Unit>(const DatabaseFailure('boom'))
          : Right<Failure, Unit>(unit);
    });
    final cubit = SplashCubit(bibleBootstrap: bibleBootstrap);
    await tester.pumpWidget(buildApp(cubit));

    cubit.initialize();
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();
    expect(find.byType(SplashErrorView), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.text('reading-placeholder'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });
}
