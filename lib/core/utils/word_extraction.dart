/// Helpers for turning a raw text selection into a dictionary lookup word.
library;

final RegExp _whitespace = RegExp(r'\s+');
final RegExp _leadingNonWordChars = RegExp(r'^[^A-Za-zÀ-ÖØ-öø-ÿ0-9]+');
final RegExp _trailingNonWordChars = RegExp(r'[^A-Za-zÀ-ÖØ-öø-ÿ0-9]+$');

/// Trims the selection and strips surrounding punctuation, e.g. `"¿Paz,"` ->
/// `'Paz'`. Accents and case are preserved. Intended for a single selected word
/// (see [countWords]); the caller is responsible for that precondition.
String extractSelectedWord(String selection) {
  final trimmed = selection.trim();
  if (trimmed.isEmpty) return '';
  return trimmed
      .replaceFirst(_leadingNonWordChars, '')
      .replaceFirst(_trailingNonWordChars, '');
}

/// Number of whitespace-separated words in a text [selection].
int countWords(String selection) {
  final trimmed = selection.trim();
  if (trimmed.isEmpty) return 0;
  return trimmed.split(_whitespace).where((word) => word.isNotEmpty).length;
}
