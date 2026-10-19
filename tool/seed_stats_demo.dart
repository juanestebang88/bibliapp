import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:bibliapp/core/utils/local_date_key.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';

/// Rebuilds the development-only demo asset from the canonical database.
///
/// Run from the repository root:
///   fvm dart run tool/seed_stats_demo.dart
///
/// It always deletes and rewrites `assets/db/bible_prepacked_demo.db`, copying
/// the canonical asset and injecting random reading marks (0..10 chapters per
/// day) across the last 7 days in `chapter_progress` and `reading_events`. The
/// canonical asset is never modified. Launch the app with
/// `--dart-define=USE_DEMO_DATA=true` to read this data.
Future<void> main() async {
  final scriptDirectory = File(Platform.script.toFilePath()).parent;
  final repositoryRoot = scriptDirectory.parent;
  final separator = Platform.pathSeparator;

  final canonicalFile = File(
    '${repositoryRoot.path}${separator}assets${separator}db'
    '${separator}bible_prepacked.db',
  );
  final demoFile = File(
    '${repositoryRoot.path}${separator}assets${separator}db'
    '${separator}bible_prepacked_demo.db',
  );

  if (!canonicalFile.existsSync()) {
    stderr.writeln('Canonical database not found: ${canonicalFile.path}');
    stderr.writeln(
      'Generate it first with fvm dart run tool/prepack_bible.dart',
    );
    exitCode = 1;
    return;
  }

  demoFile.parent.createSync(recursive: true);
  if (demoFile.existsSync()) {
    demoFile.deleteSync();
  }
  demoFile.writeAsBytesSync(canonicalFile.readAsBytesSync(), flush: true);

  final database = ReadingDatabase(
    executor: NativeDatabase(demoFile, logStatements: false),
  );

  try {
    await database.customStatement('DELETE FROM chapter_progress');
    await database.customStatement('DELETE FROM reading_events');
    final marks = await _seed(database);
    await database.customStatement('VACUUM');
    stdout.writeln('Generated ${demoFile.path} ($marks reading marks, 7 days)');
  } finally {
    await database.close();
  }
}

/// Inserts [marks] random reading events spread over the last 7 local days,
/// picking chapters inside the real chapter count of each book.
Future<int> _seed(ReadingDatabase database) async {
  final random = Random();
  final chapterRows = await database
      .customSelect(
        'SELECT book, MAX(chapter) AS total FROM verses GROUP BY book',
      )
      .get();
  final totals = <String, int>{
    for (final row in chapterRows)
      row.read<String>('book'): row.read<int>('total'),
  };
  final books = totals.keys.toList(growable: false);
  if (books.isEmpty) {
    throw StateError('The canonical database has no verses.');
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final used = <String>{};
  var marks = 0;

  for (var daysAgo = 6; daysAgo >= 0; daysAgo--) {
    final day = today.subtract(Duration(days: daysAgo));
    final dateKey = localDateKey(day);
    final completedAt = DateTime(
      day.year,
      day.month,
      day.day,
      20,
    ).millisecondsSinceEpoch;
    final chaptersToday = random.nextInt(11); // 0..10

    for (var index = 0; index < chaptersToday; index++) {
      final book = books[random.nextInt(books.length)];
      final chapter = 1 + random.nextInt(totals[book]!);
      if (!used.add('$book:$chapter')) continue;

      final verseCount = 5 + random.nextInt(26);
      await database.customInsert(
        'INSERT OR REPLACE INTO chapter_progress '
        '(book, chapter, last_verse_read, is_complete, completed_at, updated_at) '
        'VALUES (?, ?, ?, 1, ?, ?)',
        variables: [
          Variable<String>(book),
          Variable<int>(chapter),
          Variable<int>(verseCount),
          Variable<int>(completedAt),
          Variable<int>(completedAt),
        ],
      );
      await database.customInsert(
        'INSERT OR REPLACE INTO reading_events '
        '(activity_date, book, chapter, verse_count) VALUES (?, ?, ?, ?)',
        variables: [
          Variable<String>(dateKey),
          Variable<String>(book),
          Variable<int>(chapter),
          Variable<int>(verseCount),
        ],
      );
      marks++;
    }
  }

  return marks;
}
