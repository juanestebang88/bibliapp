import 'package:bibliapp/core/bootstrap/bible_bootstrap.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:bibliapp/features/splash/presentation/cubit/splash_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockBibleBootstrap extends Mock implements BibleBootstrap {}

void main() {
  late _MockBibleBootstrap bibleBootstrap;

  setUp(() {
    bibleBootstrap = _MockBibleBootstrap();
  });

  test('initial state is loading', () {
    final cubit = SplashCubit(bibleBootstrap: bibleBootstrap);
    expect(cubit.state.status, SplashStatus.loading);
    cubit.close();
  });

  blocTest<SplashCubit, SplashState>(
    'emits ready after a successful import',
    build: () {
      when(() => bibleBootstrap.ensureImported())
          .thenAnswer((_) async => const Right<Failure, Unit>(unit));
      return SplashCubit(bibleBootstrap: bibleBootstrap);
    },
    act: (cubit) => cubit.initialize(),
    wait: const Duration(milliseconds: 1300),
    expect: () => const [
      SplashState(status: SplashStatus.loading),
      SplashState(status: SplashStatus.ready),
    ],
  );

  blocTest<SplashCubit, SplashState>(
    'emits failure when the import fails',
    build: () {
      when(() => bibleBootstrap.ensureImported()).thenAnswer(
        (_) async => const Left<Failure, Unit>(DatabaseFailure('boom')),
      );
      return SplashCubit(bibleBootstrap: bibleBootstrap);
    },
    act: (cubit) => cubit.initialize(),
    wait: const Duration(milliseconds: 1300),
    expect: () => const [
      SplashState(status: SplashStatus.loading),
      SplashState(status: SplashStatus.failure, errorMessage: 'boom'),
    ],
  );

  blocTest<SplashCubit, SplashState>(
    'retry re-runs the import and reaches ready',
    build: () {
      var calls = 0;
      when(() => bibleBootstrap.ensureImported()).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Left<Failure, Unit>(DatabaseFailure('boom'))
            : const Right<Failure, Unit>(unit);
      });
      return SplashCubit(bibleBootstrap: bibleBootstrap);
    },
    act: (cubit) async {
      await cubit.initialize();
      await cubit.retry();
    },
    wait: const Duration(milliseconds: 2600),
    expect: () => const [
      SplashState(status: SplashStatus.loading),
      SplashState(status: SplashStatus.failure, errorMessage: 'boom'),
      SplashState(status: SplashStatus.loading),
      SplashState(status: SplashStatus.ready),
    ],
  );
}
