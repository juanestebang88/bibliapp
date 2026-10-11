import 'dart:io';

import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/connectivity_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Probes reachability by opening a socket against a known host.
class ConnectivityRepositoryImpl implements ConnectivityRepository {
  const ConnectivityRepositoryImpl({
    this.host = 'dle.rae.es',
    this.port = 443,
    this.timeout = const Duration(seconds: 3),
  });

  final String host;
  final int port;
  final Duration timeout;

  @override
  Future<Either<Failure, bool>> hasInternet() async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return const Right(true);
    } on SocketException {
      return const Right(false);
    } on Object catch (error) {
      return Left(ConnectivityFailure(error.toString()));
    }
  }
}
