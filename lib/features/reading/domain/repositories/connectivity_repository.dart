import 'package:bibliapp/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Contract for probing internet reachability.
abstract class ConnectivityRepository {
  /// Returns `Right(true)` when the target host is reachable, `Right(false)`
  /// when it is unreachable and `Left` on an unexpected error.
  Future<Either<Failure, bool>> hasInternet();
}
