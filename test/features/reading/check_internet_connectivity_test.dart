import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/connectivity_repository.dart';
import 'package:bibliapp/features/reading/domain/usecases/check_internet_connectivity.dart';

class _MockConnectivityRepository extends Mock
    implements ConnectivityRepository {}

void main() {
  late _MockConnectivityRepository repository;
  late CheckInternetConnectivity useCase;

  setUp(() {
    repository = _MockConnectivityRepository();
    useCase = CheckInternetConnectivity(repository);
  });

  test('returns true when the host is reachable', () async {
    when(() => repository.hasInternet())
        .thenAnswer((_) async => const Right<Failure, bool>(true));

    expect(await useCase(), const Right<Failure, bool>(true));
  });

  test('returns false when the host is unreachable', () async {
    when(() => repository.hasInternet())
        .thenAnswer((_) async => const Right<Failure, bool>(false));

    expect(await useCase(), const Right<Failure, bool>(false));
  });

  test('propagates a failure', () async {
    when(() => repository.hasInternet()).thenAnswer(
      (_) async => const Left<Failure, bool>(ConnectivityFailure('boom')),
    );

    final result = await useCase();

    expect(result.isLeft(), isTrue);
  });
}
