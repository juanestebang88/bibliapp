import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/utils/search_text.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_local_data_source.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';

void main() {
  late ReadingDatabase database;
  late ReadingLocalDataSource dataSource;

  setUp(() {
    database = ReadingDatabase(executor: NativeDatabase.memory());
    dataSource = ReadingLocalDataSource(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> import(List<VerseEntity> verses) =>
      dataSource.importRV1960(verses);

  test('matches whole words regardless of case', () async {
    await import(const [
      VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'La PAZ sea'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'pazco en el'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 3, text: 'capaz de todo'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 4, text: 'la paz. amén'),
    ]);

    final results = await dataSource.searchVerses(searchQueryWords('paz'));

    expect(results.map((v) => v.verse), [1, 4]);
  });

  test('matches ignoring accents', () async {
    await import(const [
      VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Está escrito'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'corazón nuevo'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 3, text: 'con esa boca'),
    ]);

    expect(
      (await dataSource.searchVerses(searchQueryWords('esta')))
          .map((v) => v.verse),
      [1],
    );
    expect(
      (await dataSource.searchVerses(searchQueryWords('corazon')))
          .map((v) => v.verse),
      [2],
    );
  });

  test('ranks verses with more matched words first', () async {
    await import(const [
      VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'La paz sea'),
      VerseEntity(book: 'exodus', chapter: 1, verse: 1, text: 'Amor eterno'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Amor y paz'),
    ]);

    final results = await dataSource.searchVerses(searchQueryWords('amor paz'));

    expect(results.map((v) => '${v.book}:${v.chapter}:${v.verse}').toList(), [
      'genesis:1:1',
      'genesis:1:2',
      'exodus:1:1',
    ]);
  });

  test('orders equal-rank results canonically by book then chapter', () async {
    await import(const [
      VerseEntity(book: 'exodus', chapter: 1, verse: 1, text: 'Otra paz'),
      VerseEntity(book: 'genesis', chapter: 2, verse: 1, text: 'Más paz'),
      VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Paz aquí'),
    ]);

    final results = await dataSource.searchVerses(searchQueryWords('paz'));

    expect(results.map((v) => '${v.book}:${v.chapter}:${v.verse}').toList(), [
      'genesis:1:1',
      'genesis:2:1',
      'exodus:1:1',
    ]);
  });

  test('limits results to 50', () async {
    final verses = List.generate(
      60,
      (i) => VerseEntity(
        book: 'psalms',
        chapter: 1,
        verse: i + 1,
        text: 'Amor sin límites',
      ),
    );
    await import(verses);

    final results = await dataSource.searchVerses(searchQueryWords('amor'));

    expect(results, hasLength(50));
  });

  test('excludes numbered chapter headings', () async {
    await import(const [
      VerseEntity(
        book: 'genesis',
        chapter: 1,
        verse: 1,
        text: 'Amor de Dios',
        isVerseNumber: true,
      ),
      VerseEntity(book: 'genesis', chapter: 1, verse: 2, text: 'Amor real'),
    ]);

    final results = await dataSource.searchVerses(searchQueryWords('amor'));

    expect(results.map((v) => v.verse), [2]);
  });
}
