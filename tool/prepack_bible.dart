import 'dart:io';

import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/data/rv1960_parser.dart';
import 'package:drift/native.dart';

/// Generates the prepackaged Bible database used by the app at first launch.
///
/// Run from the repository root:
///   fvm dart run tool/prepack_bible.dart
///
/// It reuses the production Drift schema and the RV1960 parser so the emitted
/// `assets/db/bible_prepacked.db` is identical to a database the app would have
/// built itself.
Future<void> main() async {
  final scriptDirectory = File(Platform.script.toFilePath()).parent;
  final repositoryRoot = scriptDirectory.parent;
  final separator = Platform.pathSeparator;

  final jsonFile = File(
    '${scriptDirectory.path}${separator}data${separator}RV1960.json',
  );
  final outputDirectory = Directory(
    '${repositoryRoot.path}${separator}assets${separator}db',
  );
  final outputFile = File(
    '${outputDirectory.path}${separator}bible_prepacked.db',
  );

  if (!jsonFile.existsSync()) {
    stderr.writeln('Source JSON not found: ${jsonFile.path}');
    exitCode = 1;
    return;
  }

  outputDirectory.createSync(recursive: true);
  if (outputFile.existsSync()) {
    outputFile.deleteSync();
  }

  final jsonString = await jsonFile.readAsString();
  final verses = parseRV1960(jsonString);

  final database = ReadingDatabase(
    executor: NativeDatabase(outputFile, logStatements: false),
  );
  final dataSource = ReadingLocalDataSource(database: database);

  try {
    await dataSource.importRV1960(verses);
    await database.customStatement('VACUUM');
    await database.customStatement(
      'PRAGMA user_version = ${database.schemaVersion}',
    );

    final row = await database
        .customSelect('SELECT COUNT(*) AS total FROM verses')
        .getSingle();
    final total = row.read<int>('total');
    stdout.writeln(
      'Generated ${outputFile.path} '
      '($total verses, schemaVersion ${database.schemaVersion})',
    );
  } finally {
    await database.close();
  }
}
