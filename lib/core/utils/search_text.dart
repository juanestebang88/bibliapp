/// Helpers for accent- and case-insensitive word matching over verse text.
library;

const Map<String, String> _diacriticMap = {
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'å': 'a',
  'ç': 'c',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ñ': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'ý': 'y',
  'ÿ': 'y',
};

/// Lowercases [text] and strips diacritics so comparisons ignore accents.
String normalizeSearchText(String text) {
  final buffer = StringBuffer();
  for (final char in text.toLowerCase().split('')) {
    buffer.write(_diacriticMap[char] ?? char);
  }
  return buffer.toString();
}

final RegExp _nonWordChars = RegExp('[^a-z0-9]');

/// Splits a raw query into unique normalized words (lowercase, no accents).
List<String> searchQueryWords(String rawQuery) {
  final words = <String>{};
  for (final token in rawQuery.split(RegExp(r'\s+'))) {
    final word = normalizeSearchText(token).replaceAll(_nonWordChars, '');
    if (word.isNotEmpty) words.add(word);
  }
  return words.toList(growable: false);
}

/// True if [normalizedWord] appears as a whole word inside [normalizedText].
bool containsSearchWord(String normalizedText, String normalizedWord) {
  if (normalizedWord.isEmpty || normalizedWord.length > normalizedText.length) {
    return false;
  }
  final pattern = RegExp('\\b${RegExp.escape(normalizedWord)}\\b');
  return pattern.hasMatch(normalizedText);
}

typedef WordRange = ({int start, int end});

/// Locates every whole-word occurrence of [normalizedWord] in the raw [text].
///
/// Comparisons are done on normalized windows so accents and case differences
/// in the source text still match (e.g. "Está" for the word "esta").
List<WordRange> searchWordRanges(String text, String normalizedWord) {
  if (normalizedWord.isEmpty) return const [];
  final ranges = <WordRange>[];
  final length = normalizedWord.length;
  for (var i = 0; i + length <= text.length; i++) {
    if (i > 0 && _isWordChar(text.codeUnitAt(i - 1))) continue;
    final end = i + length;
    if (end < text.length && _isWordChar(text.codeUnitAt(end))) continue;
    if (normalizeSearchText(text.substring(i, end)) == normalizedWord) {
      ranges.add((start: i, end: end));
    }
  }
  return ranges;
}

final RegExp _isWordCharPattern = RegExp('[A-Za-zÀ-ÖØ-öø-ÿ0-9]');

bool _isWordChar(int codeUnit) {
  return _isWordCharPattern.hasMatch(String.fromCharCode(codeUnit));
}

/// Spelling variants of a normalized word covering Spanish diacritics.
///
/// Used to build inclusive SQLite `LIKE` candidates so accented verses are not
/// dropped before the exact normalized match runs in Dart.
List<String> searchAccentVariants(String word) {
  const replacements = <String, List<String>>{
    'a': ['a', 'á'],
    'e': ['e', 'é'],
    'i': ['i', 'í'],
    'o': ['o', 'ó'],
    'u': ['u', 'ú', 'ü'],
    'n': ['n', 'ñ'],
  };
  var variants = <String>[''];
  for (final char in word.split('')) {
    final options = replacements[char] ?? [char];
    final next = <String>[];
    for (final prefix in variants) {
      for (final option in options) {
        next.add('$prefix$option');
      }
    }
    variants = next;
    if (variants.length > 512) return [word];
  }
  return variants;
}
