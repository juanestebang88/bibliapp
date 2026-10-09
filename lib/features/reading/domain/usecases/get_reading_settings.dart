import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetReadingSettings {
  final ReadingRepository _repository;

  const GetReadingSettings(this._repository);

  Future<Either<Failure, ReadingSettingsEntity?>> call() =>
      _repository.getReadingSettings();
}
