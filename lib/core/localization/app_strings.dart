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
  static const loadingBible = 'Cargando la Biblia…';
  static const errorLoadingBible = 'No se pudo cargar la Biblia';
  static const emptyChapter =
      'No hay versículos disponibles para este capítulo.';
  static const retry = 'Reintentar';
  static const selectPassage = 'Seleccionar pasaje';
  static const oldTestament = 'AT';
  static const newTestament = 'NT';
  static const back = 'Volver';
  static const close = 'Cerrar';
  static const search = 'Buscar';
  static const searchHint = 'Busca una palabra o frase';
  static const searchResults = 'Resultados de búsqueda';
  static const noResults = 'No se encontraron resultados';
  static const backToResults = 'Volver a los resultados';
  static const backToMyReading = 'Volver a mi lectura actual';
  static const continueFromHere = 'Continuar mi lectura desde aquí';
  static const emptyQuery = 'Escribe al menos una palabra para buscar';
  static const copyWord = 'Copiar';
  static const searchInRae = 'Ver significado';
  static const shareVerse = 'Compartir versículo';
  static const needsInternetForRae =
      'Para usar esta opción necesitas conexión a internet';
  static const noInternetConnection = 'Sin conexión a internet';
  static const loadingRae = 'Cargando definición';
  static const errorLoadingRae = 'No se pudo cargar la definición';
  static const underline = 'Subrayar';
  static const underlineVerse = 'Subrayar versículo';
  static const changeColor = 'Cambiar color';
  static const removeUnderline = 'Quitar subrayado';
  static const chooseColor = 'Elige un color';
  static const colorGreen = 'Verde';
  static const colorBlue = 'Azul';
  static const colorYellow = 'Amarillo';
  static const colorCopper = 'Cobre';

  static const chapterProgress = 'Progreso del capítulo';
  static const markChapterComplete = 'Marcar capítulo completo';
  static String saveUpToVerse(int verseNumber) =>
      'Guardar hasta el versículo $verseNumber';
  static const upToWhichVerse = '¿Hasta qué versículo llegaste?';
  static const unmarkChapter = 'Desmarcar capítulo';
  static const readingProgressButton = 'Progreso de lectura';
  static const tapToConfirm = 'Toca para confirmar la lectura';
  static const tapToSaveReading = 'Toca el botón para guardar tu lectura';
  static const chapterMarkedComplete = 'Capítulo leído';
  static String percent(int value) => '$value %';
  static String verseCount(int total) =>
      total == 1 ? '1 versículo' : '$total versículos';

  static String resultsCount(int count) =>
      count == 1 ? '1 resultado' : '$count resultados';

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

  static String passageTitle(String bookId, int chapter) =>
      '${bookName(bookId)} Cap. $chapter';

  static String readingLocationTitle(String bookId, int chapter) =>
      '${bookName(bookId)} · Cap. $chapter';

  static String chapter(int number) => 'Capítulo $number';

  static const dailyVerseLabel = 'Versículo del día';
  static const continueReading = 'Continuar lectura';
  static const errorLoadingHome = 'No se pudo cargar la pantalla de inicio';
  static const today = 'Hoy';
  static const dayNamesShort = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  static String shortDayName(int weekday) {
    final index = weekday - 1;
    if (index < 0 || index >= dayNamesShort.length) return '';
    return dayNamesShort[index];
  }

  static String chaptersReadSummary(int read, int total) =>
      '$read de $total leídos';

  static String verseReference(String bookId, int chapter, int verse) =>
      '${bookName(bookId)} $chapter:$verse';

  static String remainingChapters(int remaining, String bookDisplayName) =>
      remaining == 1
      ? 'Queda 1 capítulo para terminar $bookDisplayName'
      : 'Quedan $remaining capítulos para terminar $bookDisplayName';

  static String bookCompleted(String bookDisplayName) =>
      'Has completado $bookDisplayName';

  // Stats screen (spec 19)
  static const statsTitle = 'Estadística';
  static const tabMyProgress = 'MI PROGRESO';
  static const tabOldTestament = 'PROGRESO AT';
  static const tabNewTestament = 'PROGRESO NT';
  static const yesterdayVsToday = 'AYER VS HOY';
  static String chaptersYesterday(int count) => 'CAPÍTULOS AYER $count';
  static String chaptersToday(int count) => '$count CAPÍTULOS HOY';
  static const durationLabel = 'DURACIÓN';
  static String durationDays(int days) => days == 1 ? '1 Día' : '$days Días';
  static const progressLabel = 'PROGRESO';
  static String weeklyChange(int percent) {
    final sign = percent > 0 ? '+' : '';
    return '$sign$percent% DESDE LA SEMANA PASADA';
  }

  static const readingsPerWeek = 'LECTURAS POR SEMANA';
  static const readingsPerMonth = 'LECTURAS POR MES';
  static const chaptersPerDayUnit = '(CAPÍTULOS/DÍA)';
  static const periodWeek = 'SEMANA';
  static const periodMonth = 'MES';
  static String bookProgress(int read, int total, int percent) =>
      '$read/$total $percent%';
  static const statsNotStarted = 'Sin iniciar';
  static const statsCompleted = 'Finalizado';
  static const bookInProgress = 'En curso';
  static String statsStartDate(String date) => 'Inicio: $date';
  static String statsEndDate(String date) => 'Fin: $date';
  static const statsNoReadings = 'Sin lecturas registradas';
  static const statsPopupClose = 'Cerrar';
  static String percentOneDecimal(double value) =>
      '${value.toStringAsFixed(1)}%';
  static const errorLoadingStats = 'No se pudieron cargar las estadísticas';
}
