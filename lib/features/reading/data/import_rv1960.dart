import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/data/rv1960_parser.dart';

Future<void> importRV1960({
  void Function(int, int)? onProgress,
  ReadingLocalDataSource? dataSource,
}) async {
  onProgress?.call(0, 3);
  final ownedDatabase = dataSource == null ? ReadingDatabase() : null;
  final localDataSource =
      dataSource ?? ReadingLocalDataSource(database: ownedDatabase!);

  try {
    if (await localDataSource.hasImportedVerses()) {
      onProgress?.call(3, 3);
      return;
    }

    final jsonString = await rootBundle.loadString('assets/data/RV1960.json');
    onProgress?.call(1, 3);
    final verses = await compute(parseRV1960, jsonString);
    onProgress?.call(2, 3);
    await localDataSource.importRV1960(verses);
    onProgress?.call(3, 3);
  } finally {
    await ownedDatabase?.close();
  }
}
