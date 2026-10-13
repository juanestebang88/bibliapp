import 'package:bibliapp/core/bootstrap/bible_bootstrap.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class EnsureBibleImported implements BibleBootstrap {
  final ReadingRepository _repository;

  const EnsureBibleImported(this._repository);

  @override
  Future<Either<Failure, Unit>> ensureImported() =>
      _repository.ensureBibleImported();
}
