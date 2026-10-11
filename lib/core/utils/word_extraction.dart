/// Helpers for turning a raw text selection into a single dictionary word.
library;

final RegExp _whitespace = RegExp(r'\s+');
final RegExp _leadingNonWordChars = RegExp(r'^[^A-Za-zÀ-ÖØ-öø-ÿ0-9]+');
final RegExp _trailingNonWordChars = RegExp(r'[^A-Za-zÀ-ÖØ-öø-ÿ0-9]+$');

/// Extracts the first word of a text [selection], trimming surrounding
/// punctuation. Accents and case are preserved, e.g. `"¿Paz,"` -> `'Paz'`.
String extractSelectedWord(String selection) {
  final trimmed = selection.trim();
  if (trimmed.isEmpty) return '';
  final token = trimmed.split(_whitespace).first;
  return token
      .replaceFirst(_leadingNonWordChars, '')
      .replaceFirst(_trailingNonWordChars, '');
}
