import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/data/repositories/connectivity_repository_impl.dart';

void main() {
  test('returns true when the host accepts the connection', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);

    final repository = ConnectivityRepositoryImpl(
      host: InternetAddress.loopbackIPv4.address,
      port: server.port,
      timeout: const Duration(seconds: 1),
    );

    expect(await repository.hasInternet(), const Right<Failure, bool>(true));
  });

  test('returns false when nothing listens on the port', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = server.port;
    await server.close();

    final repository = ConnectivityRepositoryImpl(
      host: InternetAddress.loopbackIPv4.address,
      port: port,
      timeout: const Duration(seconds: 1),
    );

    expect(await repository.hasInternet(), const Right<Failure, bool>(false));
  });

  test('returns a failure when the probe itself is invalid', () async {
    final repository = ConnectivityRepositoryImpl(
      host: InternetAddress.loopbackIPv4.address,
      port: -1,
      timeout: const Duration(seconds: 1),
    );

    final result = await repository.hasInternet();

    expect(result.isLeft(), isTrue);
    expect(
      result.getLeft().getOrElse(() => throw StateError('expected left')),
      isA<ConnectivityFailure>(),
    );
  });
}
