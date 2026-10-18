import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/features/reading/data/rv1960_parser.dart';

void main() {
  test('parses all books and verses from the RV1960 source file', () {
    final jsonString = File('tool/data/RV1960.json').readAsStringSync();

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
