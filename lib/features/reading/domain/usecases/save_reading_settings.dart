import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_settings_entity.dart';
import 'package:bibliapp/features/reading/domain/repositories/reading_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveReadingSettings {
  final ReadingRepository _repository;

  const SaveReadingSettings(this._repository);

  Future<Either<Failure, bool>> call(ReadingSettingsEntity settings) =>
      _repository.saveReadingSettings(settings);
}
