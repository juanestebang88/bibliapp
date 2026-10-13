import 'package:equatable/equatable.dart';

enum SplashStatus { loading, ready, failure }

class SplashState extends Equatable {
  final SplashStatus status;
  final String? errorMessage;

  const SplashState({this.status = SplashStatus.loading, this.errorMessage});

  @override
  List<Object?> get props => [status, errorMessage];
}
