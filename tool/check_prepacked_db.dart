import 'dart:io';

import 'package:drift/native.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';

/// Fails when the canonical prepackaged database carries user data.
///
/// Run from the repository root:
///   fvm dart run tool/check_prepacked_db.dart
///
/// The canonical asset must only hold the Bible text: any row in
/// `chapter_progress` or `reading_events` means demo or real data leaked in.
/// Exit code is 0 when clean and 1 when dirty. The check runs on a temporary
/// copy, so opening the database never touches the canonical asset.
Future<void> main() async {
  final scriptDirectory = File(Platform.script.toFilePath()).parent;
  final repositoryRoot = scriptDirectory.parent;
  final canonicalFile = File(
    '${repositoryRoot.path}${Platform.pathSeparator}assets'
    '${Platform.pathSeparator}db${Platform.pathSeparator}bible_prepacked.db',
  );

  if (!canonicalFile.existsSync()) {
    stderr.writeln('Canonical database not found: ${canonicalFile.path}');
    exitCode = 1;
    return;
  }

  final tempDirectory = Directory.systemTemp.createTempSync('bible_check');
  final tempFile = File(
    '${tempDirectory.path}${Platform.pathSeparator}bible_prepacked.db',
  );
  tempFile.writeAsBytesSync(canonicalFile.readAsBytesSync(), flush: true);

  final database = ReadingDatabase(
    executor: NativeDatabase(tempFile, logStatements: false),
  );

  try {
    final progress = await _count(database, 'chapter_progress');
    final events = await _count(database, 'reading_events');
    if (progress > 0 || events > 0) {
      stderr.writeln(
        'Canonical database is dirty: $progress chapter_progress rows and '
        '$events reading_events rows.',
      );
      stderr.writeln(
        'The canonical asset must never carry user data. Regenerate it with '
        'fvm dart run tool/prepack_bible.dart',
      );
      exitCode = 1;
      return;
    }
    stdout.writeln('Canonical database is clean (no user rows).');
  } finally {
    await database.close();
    tempDirectory.deleteSync(recursive: true);
  }
}

Future<int> _count(ReadingDatabase database, String table) async {
  final row = await database
      .customSelect('SELECT COUNT(*) AS total FROM $table')
      .getSingle();
  return row.read<int>('total');
}
