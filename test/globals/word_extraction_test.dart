import 'package:flutter_test/flutter_test.dart';
import 'package:bibliapp/core/utils/word_extraction.dart';

void main() {
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

  test('trims surrounding punctuation', () {
    expect(extractSelectedWord('¿Paz,'), 'Paz');
    expect(extractSelectedWord('(amor)'), 'amor');
    expect(extractSelectedWord('“vida”'), 'vida');
    expect(extractSelectedWord('fe.'), 'fe');
  });

  test('takes the first word when several words are selected', () {
    expect(extractSelectedWord('la paz sea'), 'la');
    expect(extractSelectedWord('  la   paz '), 'la');
  });
}
