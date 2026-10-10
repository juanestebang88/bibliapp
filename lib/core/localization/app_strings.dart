class AppStrings {
  const AppStrings._();

  static const previousChapter = 'Capítulo anterior';
  static const nextChapter = 'Capítulo siguiente';
  static const previous = 'Anterior';
  static const next = 'Siguiente';
  static const decreaseTextSize = 'Reducir tamaño del texto';
  static const increaseTextSize = 'Aumentar tamaño del texto';
  static const settings = 'Ajustes';
  static const home = 'Inicio';
  static const reading = 'Lectura';
  static const statistics = 'Estadísticas';
  static const loading = 'Cargando lectura';
  static const emptyChapter =
      'No hay versículos disponibles para este capítulo.';
  static const retry = 'Reintentar';

  static const bookNames = <String, String>{
    'genesis': 'Génesis',
    'exodus': 'Éxodo',
    'leviticus': 'Levítico',
    'numbers': 'Números',
    'deuteronomy': 'Deuteronomio',
    'joshua': 'Josué',
    'judges': 'Jueces',
    'ruth': 'Rut',
    '1samuel': '1 Samuel',
    '2samuel': '2 Samuel',
    '1kings': '1 Reyes',
    '2kings': '2 Reyes',
    '1chronicles': '1 Crónicas',
    '2chronicles': '2 Crónicas',
    'ezra': 'Esdras',
    'nehemiah': 'Nehemías',
    'esther': 'Ester',
    'job': 'Job',
    'psalms': 'Salmos',
    'proverbs': 'Proverbios',
    'ecclesiastes': 'Eclesiastés',
    'songofsolomon': 'Cantares',
    'isaiah': 'Isaías',
    'jeremiah': 'Jeremías',
    'lamentations': 'Lamentaciones',
    'ezekiel': 'Ezequiel',
    'daniel': 'Daniel',
    'hosea': 'Oseas',
    'joel': 'Joel',
    'amos': 'Amós',
    'obadiah': 'Abdías',
    'jonah': 'Jonás',
    'micah': 'Miqueas',
    'nahum': 'Nahúm',
    'habakkuk': 'Habacuc',
    'zephaniah': 'Sofonías',
    'haggai': 'Hageo',
    'zechariah': 'Zacarías',
    'malachi': 'Malaquías',
    'matthew': 'Mateo',
    'mark': 'Marcos',
    'luke': 'Lucas',
    'john': 'Juan',
    'acts': 'Hechos',
    'romans': 'Romanos',
    '1corinthians': '1 Corintios',
    '2corinthians': '2 Corintios',
    'galatians': 'Gálatas',
    'ephesians': 'Efesios',
    'philippians': 'Filipenses',
    'colossians': 'Colosenses',
    '1thessalonians': '1 Tesalonicenses',
    '2thessalonians': '2 Tesalonicenses',
    '1timothy': '1 Timoteo',
    '2timothy': '2 Timoteo',
    'titus': 'Tito',
    'philemon': 'Filemón',
    'hebrews': 'Hebreos',
    'james': 'Santiago',
    '1peter': '1 Pedro',
    '2peter': '2 Pedro',
    '1john': '1 Juan',
    '2john': '2 Juan',
    '3john': '3 Juan',
    'jude': 'Judas',
    'revelation': 'Apocalipsis',
  };

  static String bookName(String id) => bookNames[id] ?? id;

  static String chapter(int number) => 'Capítulo $number';
}
