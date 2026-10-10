import 'package:drift/drift.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';

class ReadingLocalDataSource {
  final ReadingDatabase database;

  ReadingLocalDataSource({required this.database});

  Future<bool> hasImportedVerses() async {
    final countExpression = database.verses.book.count();
    final count =
        await (database.selectOnly(database.verses)
              ..addColumns([countExpression]))
            .map((row) => row.read(countExpression))
            .getSingle();
    return (count ?? 0) > 0;
  }

  Future<void> importRV1960(Iterable<VerseEntity> verses) async {
    await database.batch((batch) {
      batch.insertAll(
        database.verses,
        verses.map(
          (verse) => VersesCompanion.insert(
            book: verse.book,
            chapter: verse.chapter,
            verse: verse.verse,
            verseText: verse.text,
            isVerseNumber: Value(verse.isVerseNumber),
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<VerseEntity?> getVerse(String book, int chapter, int verse) async {
    final row =
        await (database.select(database.verses)..where(
              (table) =>
                  table.book.equals(book) &
                  table.chapter.equals(chapter) &
                  table.verse.equals(verse),
            ))
            .getSingleOrNull();

    return row == null ? null : _toEntity(row);
  }

  Future<List<VerseEntity>> getChapterVerses(String book, int chapter) async {
    final rows =
        await (database.select(database.verses)
              ..where(
                (table) =>
                    table.book.equals(book) & table.chapter.equals(chapter),
              )
              ..orderBy([(table) => OrderingTerm.asc(table.verse)]))
            .get();

    return rows.map(_toEntity).toList(growable: false);
  }

  Future<int> getMaxChapter(String book) async {
    final maxChapter = database.verses.chapter.max();
    final row =
        await (database.selectOnly(database.verses)
              ..addColumns([maxChapter])
              ..where(database.verses.book.equals(book)))
            .getSingle();
    return row.read(maxChapter) ?? 0;
  }

  Future<void> saveReadingProgress(ReadingProgressEntity progress) async {
    await database
        .into(database.readingProgress)
        .insertOnConflictUpdate(
          ReadingProgressCompanion.insert(
            id: const Value(1),
            lastBook: progress.lastBook,
            lastChapter: progress.lastChapter,
          ),
        );
  }

  Future<ReadingProgressEntity?> getReadingProgress() async {
    final row = await database
        .select(database.readingProgress)
        .getSingleOrNull();
    if (row == null) return null;

    return ReadingProgressEntity(
      lastBook: row.lastBook,
      lastChapter: row.lastChapter,
    );
  }

  Future<int?> getFontSize() async {
    final row = await database
        .select(database.readingSettings)
        .getSingleOrNull();
    return row?.fontSize;
  }

  Future<void> saveFontSize(int fontSize) async {
    await database
        .into(database.readingSettings)
        .insertOnConflictUpdate(
          ReadingSettingsCompanion.insert(
            id: const Value(1),
            fontSize: Value(fontSize),
          ),
        );
  }

  Future<void> clearAllData() async {
    await database.delete(database.verses).go();
    await database.delete(database.readingProgress).go();
    await database.delete(database.readingSettings).go();
  }

  VerseEntity _toEntity(Verse row) => VerseEntity(
    book: row.book,
    chapter: row.chapter,
    verse: row.verse,
    text: row.verseText,
    isVerseNumber: row.isVerseNumber,
  );
}
