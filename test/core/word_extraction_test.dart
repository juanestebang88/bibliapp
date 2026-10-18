import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/utils/word_extraction.dart';

void main() {
  group('extractSelectedWord', () {
    test('returns an empty string for an empty selection', () {
      expect(extractSelectedWord(''), '');
      expect(extractSelectedWord('   '), '');
    });

    test('returns the selected word untouched', () {
      expect(extractSelectedWord('paz'), 'paz');
    });

    test('keeps accents and case', () {
      expect(extractSelectedWord('Corazón'), 'Corazón');
      expect(extractSelectedWord('Jesús'), 'Jesús');
    });

    test('trims surrounding whitespace and punctuation', () {
      expect(extractSelectedWord('  paz '), 'paz');
      expect(extractSelectedWord('¿Paz,'), 'Paz');
      expect(extractSelectedWord('(amor)'), 'amor');
      expect(extractSelectedWord('“vida”'), 'vida');
      expect(extractSelectedWord('fe.'), 'fe');
    });
  });

  group('countWords', () {
    test('counts zero for an empty selection', () {
      expect(countWords(''), 0);
      expect(countWords('   '), 0);
    });

    test('counts the whitespace-separated words', () {
      expect(countWords('paz'), 1);
      expect(countWords('la paz'), 2);
      expect(countWords('  la   paz  sea '), 3);
    });
  });
}
