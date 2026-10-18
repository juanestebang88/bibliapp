import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class EnsureBibleImported {
  final ReadingRepository _repository;

  const EnsureBibleImported(this._repository);

  Future<Either<Failure, Unit>> ensureImported() =>
      _repository.ensureBibleImported();
}
