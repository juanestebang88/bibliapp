import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/usecases/ensure_bible_imported.dart';
import 'package:bibliapp/features/reading/presentation/cubit/splash_cubit.dart';
import 'package:bibliapp/features/reading/presentation/cubit/splash_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockEnsureBibleImported extends Mock implements EnsureBibleImported {}

void main() {
  late _MockEnsureBibleImported ensureBibleImported;

  setUp(() {
    ensureBibleImported = _MockEnsureBibleImported();
  });

  test('initial state is loading', () {
    final cubit = SplashCubit(ensureBibleImported: ensureBibleImported);
    expect(cubit.state.status, SplashStatus.loading);
    cubit.close();
  });

  blocTest<SplashCubit, SplashState>(
    'emits ready after a successful import',
    build: () {
      when(() => ensureBibleImported())
          .thenAnswer((_) async => const Right<Failure, Unit>(unit));
      return SplashCubit(ensureBibleImported: ensureBibleImported);
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
      when(() => ensureBibleImported()).thenAnswer(
        (_) async => const Left<Failure, Unit>(DatabaseFailure('boom')),
      );
      return SplashCubit(ensureBibleImported: ensureBibleImported);
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
      when(() => ensureBibleImported()).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Left<Failure, Unit>(DatabaseFailure('boom'))
            : const Right<Failure, Unit>(unit);
      });
      return SplashCubit(ensureBibleImported: ensureBibleImported);
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
