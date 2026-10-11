import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/connectivity_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckInternetConnectivity {
  final ConnectivityRepository _repository;

  const CheckInternetConnectivity(this._repository);

  Future<Either<Failure, bool>> call() => _repository.hasInternet();
}
