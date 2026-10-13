import 'package:bibliapp/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Port for the app bootstrap step that guarantees the Bible text is available
/// locally before the reading feature can be used.
///
/// It lives in `core/` so the splash feature can depend on it without
/// importing the internals of the reading feature, which provides the
/// implementation.
abstract class BibleBootstrap {
  Future<Either<Failure, Unit>> ensureImported();
}
