import 'package:drift/drift.dart';
import 'package:bibliapp/core/utils/search_text.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/domain/book_order.dart';
import 'package:bibliapp/features/reading/domain/entities/chapter_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/daily_verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_day_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/reading_progress_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_highlight_entity.dart';

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

  /// Opens the database (seeding it from the prepackaged asset on first run)
  /// and verifies the Bible text is available. No JSON is parsed at runtime.
  Future<void> ensureBibleReady() async {
    final ready = await hasImportedVerses();
    if (!ready) {
      throw StateError('Prepackaged Bible database is missing or empty.');
    }
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

  Future<List<VerseEntity>> searchVerses(
    List<String> words, {
    int limit = 50,
  }) async {
    if (words.isEmpty) return const [];

    final expressions = <Expression<bool>>[];
    for (final word in words) {
      for (final variant in searchAccentVariants(word)) {
        expressions.add(database.verses.verseText.lower().like('%$variant%'));
      }
    }
    if (expressions.isEmpty) return const [];

    final rows = await (database.select(
      database.verses,
    )..where((table) => expressions.reduce((a, b) => a | b))).get();

    final matches = <({VerseEntity verse, int matchCount})>[];
    for (final row in rows) {
      if (row.isVerseNumber) continue;
      final normalizedText = normalizeSearchText(row.verseText);
      final matchedWords = <String>[];
      for (final word in words) {
        if (containsSearchWord(normalizedText, word)) {
          matchedWords.add(word);
        }
      }
      if (matchedWords.isNotEmpty) {
        matches.add((verse: _toEntity(row), matchCount: matchedWords.length));
      }
    }

    matches.sort((a, b) {
      final countComparison = b.matchCount.compareTo(a.matchCount);
      if (countComparison != 0) return countComparison;
      final bookComparison = _bookOrderIndex(a.verse.book)
          .compareTo(_bookOrderIndex(b.verse.book));
      if (bookComparison != 0) return bookComparison;
      final chapterComparison = a.verse.chapter.compareTo(b.verse.chapter);
      if (chapterComparison != 0) return chapterComparison;
      return a.verse.verse.compareTo(b.verse.verse);
    });

    return matches
        .take(limit)
        .map((match) => match.verse)
        .toList(growable: false);
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

  Future<ChapterProgressEntity?> getChapterProgress(
    String book,
    int chapter,
  ) async {
    final row =
        await (database.select(database.chapterProgress)..where(
              (table) =>
                  table.book.equals(book) & table.chapter.equals(chapter),
            ))
            .getSingleOrNull();

    return row == null ? null : _toChapterProgressEntity(row);
  }

  Future<void> saveChapterProgress(ChapterProgressEntity progress) async {
    await database
        .into(database.chapterProgress)
        .insertOnConflictUpdate(
          ChapterProgressCompanion.insert(
            book: progress.book,
            chapter: progress.chapter,
            lastVerseRead: Value(progress.lastVerseRead),
            isComplete: Value(progress.isComplete),
            completedAt: Value(progress.completedAt?.millisecondsSinceEpoch),
          ),
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
    await database.delete(database.chapterProgress).go();
    await database.delete(database.verseHighlights).go();
    await database.delete(database.dailyVerses).go();
    await database.delete(database.readingEvents).go();
  }

  /// Picks a random real verse (no verse-number markers) from the canon.
  Future<DailyVerseEntity> getRandomVerse() async {
    final query = database.customSelect(
      'SELECT book, chapter, verse, text FROM verses '
      'WHERE is_verse_number = 0 ORDER BY RANDOM() LIMIT 1',
      readsFrom: {database.verses},
    );
    final result = await query.get();
    if (result.isEmpty) {
      throw StateError('No verses available for the daily verse.');
    }
    final row = result.first;
    return DailyVerseEntity(
      book: row.read<String>('book'),
      chapter: row.read<int>('chapter'),
      verse: row.read<int>('verse'),
      text: row.read<String>('text'),
    );
  }

  /// Saved daily verse row (without text) for [day], or null if not saved.
  Future<DailyVerseEntity?> getSavedDailyVerse(String day) async {
    final row =
        await (database.select(database.dailyVerses)
              ..where((table) => table.day.equals(day) & table.id.equals(1)))
            .getSingleOrNull();
    if (row == null) return null;
    return DailyVerseEntity(
      book: row.book,
      chapter: row.chapter,
      verse: row.verse,
      text: '',
    );
  }

  /// Persists the daily verse as the single row (id = 1).
  Future<void> saveDailyVerse(DailyVerseEntity dailyVerse, String day) async {
    await database
        .into(database.dailyVerses)
        .insertOnConflictUpdate(
          DailyVersesCompanion.insert(
            id: const Value(1),
            day: day,
            book: dailyVerse.book,
            chapter: dailyVerse.chapter,
            verse: dailyVerse.verse,
          ),
        );
  }

  /// Upserts a reading event keeping the max verse count per
  /// (activityDate, book, chapter). Returns the stored verse count.
  Future<int> markReadingEvent(
    String activityDate,
    String book,
    int chapter,
    int verseCount,
  ) async {
    final existing =
        await (database.select(database.readingEvents)..where(
              (table) =>
                  table.activityDate.equals(activityDate) &
                  table.book.equals(book) &
                  table.chapter.equals(chapter),
            ))
            .getSingleOrNull();
    if (existing != null && existing.verseCount >= verseCount) {
      return existing.verseCount;
    }
    await database
        .into(database.readingEvents)
        .insertOnConflictUpdate(
          ReadingEventsCompanion.insert(
            activityDate: activityDate,
            book: book,
            chapter: chapter,
            verseCount: verseCount,
          ),
        );
    return verseCount;
  }

  /// Number of fully completed chapters of [book].
  Future<int> countCompletedChapters(String book) async {
    final countCompleted = database.chapterProgress.book.count();
    final row =
        await (database.selectOnly(database.chapterProgress)
              ..addColumns([countCompleted])
              ..where(
                database.chapterProgress.book.equals(book) &
                    database.chapterProgress.isComplete.equals(true),
              ))
            .getSingle();
    return row.read(countCompleted) ?? 0;
  }

  /// Reading totals for each requested local date.
  Future<List<ReadingDayEntity>> getReadingDayTotals(List<String> dates) async {
    if (dates.isEmpty) return const [];
    final rowCount = database.readingEvents.activityDate.count();
    final verseSum = database.readingEvents.verseCount.sum();
    final rows =
        await (database.selectOnly(database.readingEvents)
              ..addColumns([
                database.readingEvents.activityDate,
                rowCount,
                verseSum,
              ])
              ..where(database.readingEvents.activityDate.isIn(dates))
              ..groupBy([database.readingEvents.activityDate]))
            .get();

    return [
      for (final row in rows)
        ReadingDayEntity(
          date: row.read(database.readingEvents.activityDate)!,
          chaptersCount: row.read(rowCount) ?? 0,
          versesCount: row.read(verseSum) ?? 0,
        ),
    ];
  }

  Future<List<VerseHighlightEntity>> getChapterHighlights(
    String book,
    int chapter,
  ) async {
    final rows =
        await (database.select(database.verseHighlights)..where(
              (table) =>
                  table.book.equals(book) & table.chapter.equals(chapter),
            ))
            .get();

    return rows.map(_toVerseHighlightEntity).toList(growable: false);
  }

  Future<VerseHighlightEntity> addVerseHighlight(
    VerseHighlightEntity highlight,
  ) async {
    final id = await database
        .into(database.verseHighlights)
        .insert(_toHighlightCompanion(highlight));
    return highlight.copyWith(id: id);
  }

  Future<void> updateVerseHighlight(VerseHighlightEntity highlight) async {
    await database
        .update(database.verseHighlights)
        .replace(_toHighlightCompanion(highlight));
  }

  Future<void> deleteVerseHighlight(int id) async {
    await (database.delete(
      database.verseHighlights,
    )..where((table) => table.id.equals(id))).go();
  }

  VerseEntity _toEntity(Verse row) => VerseEntity(
    book: row.book,
    chapter: row.chapter,
    verse: row.verse,
    text: row.verseText,
    isVerseNumber: row.isVerseNumber,
  );

  ChapterProgressEntity _toChapterProgressEntity(ChapterProgressData row) =>
      ChapterProgressEntity(
        book: row.book,
        chapter: row.chapter,
        lastVerseRead: row.lastVerseRead,
        isComplete: row.isComplete,
        completedAt: row.completedAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row.completedAt!),
      );

  VerseHighlightEntity _toVerseHighlightEntity(VerseHighlight row) =>
      VerseHighlightEntity(
        id: row.id,
        book: row.book,
        chapter: row.chapter,
        verse: row.verse,
        startOffset: row.startOffset,
        endOffset: row.endOffset,
        color: _colorFromKey(row.colorKey),
        createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  VerseHighlightsCompanion _toHighlightCompanion(
    VerseHighlightEntity highlight,
  ) => VerseHighlightsCompanion(
    id: highlight.id == null ? const Value.absent() : Value(highlight.id!),
    book: Value(highlight.book),
    chapter: Value(highlight.chapter),
    verse: Value(highlight.verse),
    startOffset: Value(highlight.startOffset),
    endOffset: Value(highlight.endOffset),
    colorKey: Value(_colorToKey(highlight.color)),
    createdAt: Value(highlight.createdAt.millisecondsSinceEpoch),
    updatedAt: Value(highlight.updatedAt.millisecondsSinceEpoch),
  );

  String _colorToKey(HighlightColor color) => color.name;

  HighlightColor _colorFromKey(String key) => HighlightColor.values.firstWhere(
    (color) => color.name == key,
    orElse: () => HighlightColor.yellow,
  );

  int _bookOrderIndex(String book) {
    final index = bibleBookOrder.indexOf(book);
    return index < 0 ? bibleBookOrder.length : index;
  }
}
