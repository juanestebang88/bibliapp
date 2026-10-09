import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/features/reading/data/rv1960_parser.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses all books and verses from the RV1960 asset', () async {
    final jsonString = await rootBundle.loadString('assets/data/RV1960.json');

    final verses = parseRV1960(jsonString);

    expect(verses.first.book, 'genesis');
    expect(verses.last.book, 'revelation');
    expect(verses.map((verse) => verse.book).toSet(), hasLength(66));
    expect(verses, isNotEmpty);
  });

  test('rejects unknown book abbreviations', () {
    const jsonString = '[{"abbrev":"unknown","chapters":[]} ]';

    expect(() => parseRV1960(jsonString), throwsFormatException);
  });
}
