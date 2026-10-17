import 'package:drift/drift.dart';

part 'reading_database.g.dart';

class Verses extends Table {
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get verseText => text().named('text')();
  BoolColumn get isVerseNumber =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {book, chapter, verse};
}

class ReadingProgress extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get lastBook => text()();
  IntColumn get lastChapter => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReadingSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get fontSize => integer().withDefault(const Constant(20))();

  @override
  Set<Column> get primaryKey => {id};
}

class ChapterProgress extends Table {
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  IntColumn get lastVerseRead => integer().withDefault(const Constant(0))();
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();
  IntColumn get completedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {book, chapter};
}

class VerseHighlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  IntColumn get startOffset => integer()();
  IntColumn get endOffset => integer()();
  TextColumn get colorKey => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

class DailyVerses extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Local date the verse was picked for ('yyyy-MM-dd').
  TextColumn get day => text()();
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReadingEvents extends Table {
  /// Local date of the day the reading was marked ('yyyy-MM-dd').
  TextColumn get activityDate => text()();
  TextColumn get book => text()();
  IntColumn get chapter => integer()();

  /// Verses marked for this chapter that day (max kept on upsert).
  IntColumn get verseCount => integer()();

  @override
  Set<Column> get primaryKey => {activityDate, book, chapter};
}

@DriftDatabase(
  tables: [
    Verses,
    ReadingProgress,
    ReadingSettings,
    ChapterProgress,
    VerseHighlights,
    DailyVerses,
    ReadingEvents,
  ],
)
class ReadingDatabase extends _$ReadingDatabase {
  ReadingDatabase({required QueryExecutor executor}) : super(executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(readingSettings);
      }
      if (from < 3) {
        await m.alterTable(TableMigration(readingProgress));
      }
      if (from < 4) {
        await m.createTable(chapterProgress);
      }
      if (from < 5) {
        await m.createTable(verseHighlights);
      }
      if (from < 6) {
        await m.createTable(dailyVerses);
        await m.createTable(readingEvents);
      }
    },
  );
}
