import 'dart:convert';

import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';

const Map<String, String> _bookIds = {
  'gn': 'genesis',
  'ex': 'exodus',
  'lv': 'leviticus',
  'nm': 'numbers',
  'dt': 'deuteronomy',
  'js': 'joshua',
  'jz': 'judges',
  'rt': 'ruth',
  '1sm': '1samuel',
  '2sm': '2samuel',
  '1rs': '1kings',
  '2rs': '2kings',
  '1cr': '1chronicles',
  '2cr': '2chronicles',
  'ed': 'ezra',
  'ne': 'nehemiah',
  'et': 'esther',
  'jó': 'job',
  'sl': 'psalms',
  'pv': 'proverbs',
  'ec': 'ecclesiastes',
  'ct': 'songofsolomon',
  'is': 'isaiah',
  'jr': 'jeremiah',
  'lm': 'lamentations',
  'ez': 'ezekiel',
  'dn': 'daniel',
  'os': 'hosea',
  'jl': 'joel',
  'am': 'amos',
  'ob': 'obadiah',
  'jn': 'jonah',
  'mq': 'micah',
  'na': 'nahum',
  'hc': 'habakkuk',
  'sf': 'zephaniah',
  'ag': 'haggai',
  'zc': 'zechariah',
  'ml': 'malachi',
  'mt': 'matthew',
  'mc': 'mark',
  'lc': 'luke',
  'jo': 'john',
  'atos': 'acts',
  'rm': 'romans',
  '1co': '1corinthians',
  '2co': '2corinthians',
  'gl': 'galatians',
  'ef': 'ephesians',
  'fp': 'philippians',
  'cl': 'colossians',
  '1ts': '1thessalonians',
  '2ts': '2thessalonians',
  '1tm': '1timothy',
  '2tm': '2timothy',
  'tt': 'titus',
  'fm': 'philemon',
  'hb': 'hebrews',
  'tg': 'james',
  '1pe': '1peter',
  '2pe': '2peter',
  '1jo': '1john',
  '2jo': '2john',
  '3jo': '3john',
  'jd': 'jude',
  'ap': 'revelation',
};

List<VerseEntity> parseRV1960(String jsonString) {
  final Object? decoded = jsonDecode(jsonString);
  if (decoded is! List<Object?>) {
    throw const FormatException('RV1960 asset must contain a list of books.');
  }

  final verses = <VerseEntity>[];
  for (final bookValue in decoded) {
    if (bookValue is! Map<String, Object?>) {
      throw const FormatException('Each RV1960 book must be an object.');
    }

    final abbreviation = bookValue['abbrev'];
    final chaptersValue = bookValue['chapters'];
    if (abbreviation is! String || chaptersValue is! List<Object?>) {
      throw const FormatException('An RV1960 book has invalid metadata.');
    }

    final bookId = _bookIds[abbreviation];
    if (bookId == null) {
      throw FormatException('Unknown RV1960 book abbreviation: $abbreviation');
    }

    for (
      var chapterIndex = 0;
      chapterIndex < chaptersValue.length;
      chapterIndex++
    ) {
      final chapterValue = chaptersValue[chapterIndex];
      if (chapterValue is! List<Object?>) {
        throw FormatException('Invalid chapter in book $abbreviation.');
      }

      for (var verseIndex = 0; verseIndex < chapterValue.length; verseIndex++) {
        final verseText = chapterValue[verseIndex];
        if (verseText is! String) {
          throw FormatException('Invalid verse in book $abbreviation.');
        }

        verses.add(
          VerseEntity(
            book: bookId,
            chapter: chapterIndex + 1,
            verse: verseIndex + 1,
            text: verseText,
          ),
        );
      }
    }
  }

  if (decoded.length != _bookIds.length) {
    throw FormatException(
      'Expected ${_bookIds.length} books, found ${decoded.length}.',
    );
  }

  return verses;
}
