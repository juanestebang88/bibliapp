import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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

@DriftDatabase(
  tables: [
    Verses,
    ReadingProgress,
    ReadingSettings,
    ChapterProgress,
    VerseHighlights,
  ],
)
class ReadingDatabase extends _$ReadingDatabase {
  ReadingDatabase({QueryExecutor? executor})
    : super(executor ?? driftDatabase(name: 'rv1960'));

  @override
  int get schemaVersion => 5;

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
    },
  );
}
