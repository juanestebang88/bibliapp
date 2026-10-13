import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';

void main() {
  test('migrates a v4 database to v5 keeping the existing data', () async {
    final legacy = ReadingDatabase(
      executor: NativeDatabase.memory(
        setup: (database) {
          database.execute('''
            CREATE TABLE verses (
              book TEXT NOT NULL,
              chapter INTEGER NOT NULL,
              verse INTEGER NOT NULL,
              text TEXT NOT NULL,
              is_verse_number INTEGER NOT NULL DEFAULT 0,
              PRIMARY KEY (book, chapter, verse)
            );
          ''');
          database.execute('''
            CREATE TABLE reading_progress (
              id INTEGER NOT NULL DEFAULT 1,
              last_book TEXT NOT NULL,
              last_chapter INTEGER NOT NULL,
              PRIMARY KEY (id)
            );
          ''');
          database.execute('''
            CREATE TABLE reading_settings (
              id INTEGER NOT NULL DEFAULT 1,
              font_size INTEGER NOT NULL DEFAULT 20,
              PRIMARY KEY (id)
            );
          ''');
          database.execute('''
            CREATE TABLE chapter_progress (
              book TEXT NOT NULL,
              chapter INTEGER NOT NULL,
              last_verse_read INTEGER NOT NULL DEFAULT 0,
              is_complete INTEGER NOT NULL DEFAULT 0,
              completed_at INTEGER,
              PRIMARY KEY (book, chapter)
            );
          ''');
          database.execute(
            "INSERT INTO reading_progress (id, last_book, last_chapter) "
            "VALUES (1, 'john', 3);",
          );
          database.execute('PRAGMA user_version = 4;');
        },
      ),
    );
    addTearDown(legacy.close);

    final highlights = await legacy.select(legacy.verseHighlights).get();
    expect(highlights, isEmpty);

    final progress = await legacy.select(legacy.readingProgress).getSingle();
    expect(progress.lastBook, 'john');
    expect(progress.lastChapter, 3);
  });
}
