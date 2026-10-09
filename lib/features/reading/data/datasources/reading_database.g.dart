// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_database.dart';

// ignore_for_file: type=lint
class $VersesTable extends Verses with TableInfo<$VersesTable, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseTextMeta = const VerificationMeta(
    'verseText',
  );
  @override
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isVerseNumberMeta = const VerificationMeta(
    'isVerseNumber',
  );
  @override
  late final GeneratedColumn<bool> isVerseNumber = GeneratedColumn<bool>(
    'is_verse_number',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verse_number" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    book,
    chapter,
    verse,
    verseText,
    isVerseNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _verseTextMeta,
        verseText.isAcceptableOrUnknown(data['text']!, _verseTextMeta),
      );
    } else if (isInserting) {
      context.missing(_verseTextMeta);
    }
    if (data.containsKey('is_verse_number')) {
      context.handle(
        _isVerseNumberMeta,
        isVerseNumber.isAcceptableOrUnknown(
          data['is_verse_number']!,
          _isVerseNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {book, chapter, verse};
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      verseText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      isVerseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verse_number'],
      )!,
    );
  }

  @override
  $VersesTable createAlias(String alias) {
    return $VersesTable(attachedDatabase, alias);
  }
}

class Verse extends DataClass implements Insertable<Verse> {
  final String book;
  final int chapter;
  final int verse;
  final String verseText;
  final bool isVerseNumber;
  const Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.verseText,
    required this.isVerseNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['text'] = Variable<String>(verseText);
    map['is_verse_number'] = Variable<bool>(isVerseNumber);
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      book: Value(book),
      chapter: Value(chapter),
      verse: Value(verse),
      verseText: Value(verseText),
      isVerseNumber: Value(isVerseNumber),
    );
  }

  factory Verse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      verseText: serializer.fromJson<String>(json['verseText']),
      isVerseNumber: serializer.fromJson<bool>(json['isVerseNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'verseText': serializer.toJson<String>(verseText),
      'isVerseNumber': serializer.toJson<bool>(isVerseNumber),
    };
  }

  Verse copyWith({
    String? book,
    int? chapter,
    int? verse,
    String? verseText,
    bool? isVerseNumber,
  }) => Verse(
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    verseText: verseText ?? this.verseText,
    isVerseNumber: isVerseNumber ?? this.isVerseNumber,
  );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
      isVerseNumber: data.isVerseNumber.present
          ? data.isVerseNumber.value
          : this.isVerseNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('verseText: $verseText, ')
          ..write('isVerseNumber: $isVerseNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(book, chapter, verse, verseText, isVerseNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.verseText == this.verseText &&
          other.isVerseNumber == this.isVerseNumber);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<String> book;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> verseText;
  final Value<bool> isVerseNumber;
  final Value<int> rowid;
  const VersesCompanion({
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.verseText = const Value.absent(),
    this.isVerseNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VersesCompanion.insert({
    required String book,
    required int chapter,
    required int verse,
    required String verseText,
    this.isVerseNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : book = Value(book),
       chapter = Value(chapter),
       verse = Value(verse),
       verseText = Value(verseText);
  static Insertable<Verse> custom({
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? verseText,
    Expression<bool>? isVerseNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (verseText != null) 'text': verseText,
      if (isVerseNumber != null) 'is_verse_number': isVerseNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VersesCompanion copyWith({
    Value<String>? book,
    Value<int>? chapter,
    Value<int>? verse,
    Value<String>? verseText,
    Value<bool>? isVerseNumber,
    Value<int>? rowid,
  }) {
    return VersesCompanion(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      verseText: verseText ?? this.verseText,
      isVerseNumber: isVerseNumber ?? this.isVerseNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (verseText.present) {
      map['text'] = Variable<String>(verseText.value);
    }
    if (isVerseNumber.present) {
      map['is_verse_number'] = Variable<bool>(isVerseNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('verseText: $verseText, ')
          ..write('isVerseNumber: $isVerseNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressTable extends ReadingProgress
    with TableInfo<$ReadingProgressTable, ReadingProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastBookMeta = const VerificationMeta(
    'lastBook',
  );
  @override
  late final GeneratedColumn<String> lastBook = GeneratedColumn<String>(
    'last_book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastChapterMeta = const VerificationMeta(
    'lastChapter',
  );
  @override
  late final GeneratedColumn<int> lastChapter = GeneratedColumn<int>(
    'last_chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastVerseMeta = const VerificationMeta(
    'lastVerse',
  );
  @override
  late final GeneratedColumn<int> lastVerse = GeneratedColumn<int>(
    'last_verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastBook,
    lastChapter,
    lastVerse,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_book')) {
      context.handle(
        _lastBookMeta,
        lastBook.isAcceptableOrUnknown(data['last_book']!, _lastBookMeta),
      );
    } else if (isInserting) {
      context.missing(_lastBookMeta);
    }
    if (data.containsKey('last_chapter')) {
      context.handle(
        _lastChapterMeta,
        lastChapter.isAcceptableOrUnknown(
          data['last_chapter']!,
          _lastChapterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastChapterMeta);
    }
    if (data.containsKey('last_verse')) {
      context.handle(
        _lastVerseMeta,
        lastVerse.isAcceptableOrUnknown(data['last_verse']!, _lastVerseMeta),
      );
    } else if (isInserting) {
      context.missing(_lastVerseMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastBook: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_book'],
      )!,
      lastChapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_chapter'],
      )!,
      lastVerse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_verse'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ReadingProgressTable createAlias(String alias) {
    return $ReadingProgressTable(attachedDatabase, alias);
  }
}

class ReadingProgressData extends DataClass
    implements Insertable<ReadingProgressData> {
  final int id;
  final String lastBook;
  final int lastChapter;
  final int lastVerse;
  final int timestamp;
  const ReadingProgressData({
    required this.id,
    required this.lastBook,
    required this.lastChapter,
    required this.lastVerse,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_book'] = Variable<String>(lastBook);
    map['last_chapter'] = Variable<int>(lastChapter);
    map['last_verse'] = Variable<int>(lastVerse);
    map['timestamp'] = Variable<int>(timestamp);
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      id: Value(id),
      lastBook: Value(lastBook),
      lastChapter: Value(lastChapter),
      lastVerse: Value(lastVerse),
      timestamp: Value(timestamp),
    );
  }

  factory ReadingProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressData(
      id: serializer.fromJson<int>(json['id']),
      lastBook: serializer.fromJson<String>(json['lastBook']),
      lastChapter: serializer.fromJson<int>(json['lastChapter']),
      lastVerse: serializer.fromJson<int>(json['lastVerse']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastBook': serializer.toJson<String>(lastBook),
      'lastChapter': serializer.toJson<int>(lastChapter),
      'lastVerse': serializer.toJson<int>(lastVerse),
      'timestamp': serializer.toJson<int>(timestamp),
    };
  }

  ReadingProgressData copyWith({
    int? id,
    String? lastBook,
    int? lastChapter,
    int? lastVerse,
    int? timestamp,
  }) => ReadingProgressData(
    id: id ?? this.id,
    lastBook: lastBook ?? this.lastBook,
    lastChapter: lastChapter ?? this.lastChapter,
    lastVerse: lastVerse ?? this.lastVerse,
    timestamp: timestamp ?? this.timestamp,
  );
  ReadingProgressData copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressData(
      id: data.id.present ? data.id.value : this.id,
      lastBook: data.lastBook.present ? data.lastBook.value : this.lastBook,
      lastChapter: data.lastChapter.present
          ? data.lastChapter.value
          : this.lastChapter,
      lastVerse: data.lastVerse.present ? data.lastVerse.value : this.lastVerse,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressData(')
          ..write('id: $id, ')
          ..write('lastBook: $lastBook, ')
          ..write('lastChapter: $lastChapter, ')
          ..write('lastVerse: $lastVerse, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lastBook, lastChapter, lastVerse, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressData &&
          other.id == this.id &&
          other.lastBook == this.lastBook &&
          other.lastChapter == this.lastChapter &&
          other.lastVerse == this.lastVerse &&
          other.timestamp == this.timestamp);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressData> {
  final Value<int> id;
  final Value<String> lastBook;
  final Value<int> lastChapter;
  final Value<int> lastVerse;
  final Value<int> timestamp;
  const ReadingProgressCompanion({
    this.id = const Value.absent(),
    this.lastBook = const Value.absent(),
    this.lastChapter = const Value.absent(),
    this.lastVerse = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    this.id = const Value.absent(),
    required String lastBook,
    required int lastChapter,
    required int lastVerse,
    required int timestamp,
  }) : lastBook = Value(lastBook),
       lastChapter = Value(lastChapter),
       lastVerse = Value(lastVerse),
       timestamp = Value(timestamp);
  static Insertable<ReadingProgressData> custom({
    Expression<int>? id,
    Expression<String>? lastBook,
    Expression<int>? lastChapter,
    Expression<int>? lastVerse,
    Expression<int>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastBook != null) 'last_book': lastBook,
      if (lastChapter != null) 'last_chapter': lastChapter,
      if (lastVerse != null) 'last_verse': lastVerse,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<int>? id,
    Value<String>? lastBook,
    Value<int>? lastChapter,
    Value<int>? lastVerse,
    Value<int>? timestamp,
  }) {
    return ReadingProgressCompanion(
      id: id ?? this.id,
      lastBook: lastBook ?? this.lastBook,
      lastChapter: lastChapter ?? this.lastChapter,
      lastVerse: lastVerse ?? this.lastVerse,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastBook.present) {
      map['last_book'] = Variable<String>(lastBook.value);
    }
    if (lastChapter.present) {
      map['last_chapter'] = Variable<int>(lastChapter.value);
    }
    if (lastVerse.present) {
      map['last_verse'] = Variable<int>(lastVerse.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('id: $id, ')
          ..write('lastBook: $lastBook, ')
          ..write('lastChapter: $lastChapter, ')
          ..write('lastVerse: $lastVerse, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $ReadingSettingsTable extends ReadingSettings
    with TableInfo<$ReadingSettingsTable, ReadingSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<int> fontSize = GeneratedColumn<int>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  @override
  List<GeneratedColumn> get $columns => [id, fontSize];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}font_size'],
      )!,
    );
  }

  @override
  $ReadingSettingsTable createAlias(String alias) {
    return $ReadingSettingsTable(attachedDatabase, alias);
  }
}

class ReadingSetting extends DataClass implements Insertable<ReadingSetting> {
  final int id;
  final int fontSize;
  const ReadingSetting({required this.id, required this.fontSize});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['font_size'] = Variable<int>(fontSize);
    return map;
  }

  ReadingSettingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingSettingsCompanion(id: Value(id), fontSize: Value(fontSize));
  }

  factory ReadingSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSetting(
      id: serializer.fromJson<int>(json['id']),
      fontSize: serializer.fromJson<int>(json['fontSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fontSize': serializer.toJson<int>(fontSize),
    };
  }

  ReadingSetting copyWith({int? id, int? fontSize}) =>
      ReadingSetting(id: id ?? this.id, fontSize: fontSize ?? this.fontSize);
  ReadingSetting copyWithCompanion(ReadingSettingsCompanion data) {
    return ReadingSetting(
      id: data.id.present ? data.id.value : this.id,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSetting(')
          ..write('id: $id, ')
          ..write('fontSize: $fontSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fontSize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSetting &&
          other.id == this.id &&
          other.fontSize == this.fontSize);
}

class ReadingSettingsCompanion extends UpdateCompanion<ReadingSetting> {
  final Value<int> id;
  final Value<int> fontSize;
  const ReadingSettingsCompanion({
    this.id = const Value.absent(),
    this.fontSize = const Value.absent(),
  });
  ReadingSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.fontSize = const Value.absent(),
  });
  static Insertable<ReadingSetting> custom({
    Expression<int>? id,
    Expression<int>? fontSize,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fontSize != null) 'font_size': fontSize,
    });
  }

  ReadingSettingsCompanion copyWith({Value<int>? id, Value<int>? fontSize}) {
    return ReadingSettingsCompanion(
      id: id ?? this.id,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<int>(fontSize.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSettingsCompanion(')
          ..write('id: $id, ')
          ..write('fontSize: $fontSize')
          ..write(')'))
        .toString();
  }
}

abstract class _$ReadingDatabase extends GeneratedDatabase {
  _$ReadingDatabase(QueryExecutor e) : super(e);
  $ReadingDatabaseManager get managers => $ReadingDatabaseManager(this);
  late final $VersesTable verses = $VersesTable(this);
  late final $ReadingProgressTable readingProgress = $ReadingProgressTable(
    this,
  );
  late final $ReadingSettingsTable readingSettings = $ReadingSettingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    verses,
    readingProgress,
    readingSettings,
  ];
}

typedef $$VersesTableCreateCompanionBuilder = VersesCompanion Function({
  required String book,
  required int chapter,
  required int verse,
  required String verseText,
  Value<bool> isVerseNumber,
  Value<int> rowid,
});
typedef $$VersesTableUpdateCompanionBuilder = VersesCompanion Function({
  Value<String> book,
  Value<int> chapter,
  Value<int> verse,
  Value<String> verseText,
  Value<bool> isVerseNumber,
  Value<int> rowid,
});

class $$VersesTableFilterComposer
    extends Composer<_$ReadingDatabase, $VersesTable> {
  $$VersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerseNumber => $composableBuilder(
    column: $table.isVerseNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VersesTableOrderingComposer
    extends Composer<_$ReadingDatabase, $VersesTable> {
  $$VersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerseNumber => $composableBuilder(
    column: $table.isVerseNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VersesTableAnnotationComposer
    extends Composer<_$ReadingDatabase, $VersesTable> {
  $$VersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);

  GeneratedColumn<bool> get isVerseNumber => $composableBuilder(
    column: $table.isVerseNumber,
    builder: (column) => column,
  );
}

class $$VersesTableTableManager
    extends
        RootTableManager<
          _$ReadingDatabase,
          $VersesTable,
          Verse,
          $$VersesTableFilterComposer,
          $$VersesTableOrderingComposer,
          $$VersesTableAnnotationComposer,
          $$VersesTableCreateCompanionBuilder,
          $$VersesTableUpdateCompanionBuilder,
          (Verse, BaseReferences<_$ReadingDatabase, $VersesTable, Verse>),
          Verse,
          PrefetchHooks Function()
        > {
  $$VersesTableTableManager(_$ReadingDatabase db, $VersesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<String> verseText = const Value.absent(),
                Value<bool> isVerseNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VersesCompanion(
                book: book,
                chapter: chapter,
                verse: verse,
                verseText: verseText,
                isVerseNumber: isVerseNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String book,
                required int chapter,
                required int verse,
                required String verseText,
                Value<bool> isVerseNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VersesCompanion.insert(
                book: book,
                chapter: chapter,
                verse: verse,
                verseText: verseText,
                isVerseNumber: isVerseNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VersesTableProcessedTableManager =
    ProcessedTableManager<
      _$ReadingDatabase,
      $VersesTable,
      Verse,
      $$VersesTableFilterComposer,
      $$VersesTableOrderingComposer,
      $$VersesTableAnnotationComposer,
      $$VersesTableCreateCompanionBuilder,
      $$VersesTableUpdateCompanionBuilder,
      (Verse, BaseReferences<_$ReadingDatabase, $VersesTable, Verse>),
      Verse,
      PrefetchHooks Function()
    >;
typedef $$ReadingProgressTableCreateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<int> id,
      required String lastBook,
      required int lastChapter,
      required int lastVerse,
      required int timestamp,
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<int> id,
      Value<String> lastBook,
      Value<int> lastChapter,
      Value<int> lastVerse,
      Value<int> timestamp,
    });

class $$ReadingProgressTableFilterComposer
    extends Composer<_$ReadingDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastBook => $composableBuilder(
    column: $table.lastBook,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastVerse => $composableBuilder(
    column: $table.lastVerse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingProgressTableOrderingComposer
    extends Composer<_$ReadingDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastBook => $composableBuilder(
    column: $table.lastBook,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastVerse => $composableBuilder(
    column: $table.lastVerse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingProgressTableAnnotationComposer
    extends Composer<_$ReadingDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastBook =>
      $composableBuilder(column: $table.lastBook, builder: (column) => column);

  GeneratedColumn<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastVerse =>
      $composableBuilder(column: $table.lastVerse, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ReadingProgressTableTableManager
    extends
        RootTableManager<
          _$ReadingDatabase,
          $ReadingProgressTable,
          ReadingProgressData,
          $$ReadingProgressTableFilterComposer,
          $$ReadingProgressTableOrderingComposer,
          $$ReadingProgressTableAnnotationComposer,
          $$ReadingProgressTableCreateCompanionBuilder,
          $$ReadingProgressTableUpdateCompanionBuilder,
          (
            ReadingProgressData,
            BaseReferences<
              _$ReadingDatabase,
              $ReadingProgressTable,
              ReadingProgressData
            >,
          ),
          ReadingProgressData,
          PrefetchHooks Function()
        > {
  $$ReadingProgressTableTableManager(
    _$ReadingDatabase db,
    $ReadingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> lastBook = const Value.absent(),
                Value<int> lastChapter = const Value.absent(),
                Value<int> lastVerse = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
              }) => ReadingProgressCompanion(
                id: id,
                lastBook: lastBook,
                lastChapter: lastChapter,
                lastVerse: lastVerse,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String lastBook,
                required int lastChapter,
                required int lastVerse,
                required int timestamp,
              }) => ReadingProgressCompanion.insert(
                id: id,
                lastBook: lastBook,
                lastChapter: lastChapter,
                lastVerse: lastVerse,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$ReadingDatabase,
      $ReadingProgressTable,
      ReadingProgressData,
      $$ReadingProgressTableFilterComposer,
      $$ReadingProgressTableOrderingComposer,
      $$ReadingProgressTableAnnotationComposer,
      $$ReadingProgressTableCreateCompanionBuilder,
      $$ReadingProgressTableUpdateCompanionBuilder,
      (
        ReadingProgressData,
        BaseReferences<
          _$ReadingDatabase,
          $ReadingProgressTable,
          ReadingProgressData
        >,
      ),
      ReadingProgressData,
      PrefetchHooks Function()
    >;
typedef $$ReadingSettingsTableCreateCompanionBuilder =
    ReadingSettingsCompanion Function({Value<int> id, Value<int> fontSize});
typedef $$ReadingSettingsTableUpdateCompanionBuilder =
    ReadingSettingsCompanion Function({Value<int> id, Value<int> fontSize});

class $$ReadingSettingsTableFilterComposer
    extends Composer<_$ReadingDatabase, $ReadingSettingsTable> {
  $$ReadingSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingSettingsTableOrderingComposer
    extends Composer<_$ReadingDatabase, $ReadingSettingsTable> {
  $$ReadingSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingSettingsTableAnnotationComposer
    extends Composer<_$ReadingDatabase, $ReadingSettingsTable> {
  $$ReadingSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);
}

class $$ReadingSettingsTableTableManager
    extends
        RootTableManager<
          _$ReadingDatabase,
          $ReadingSettingsTable,
          ReadingSetting,
          $$ReadingSettingsTableFilterComposer,
          $$ReadingSettingsTableOrderingComposer,
          $$ReadingSettingsTableAnnotationComposer,
          $$ReadingSettingsTableCreateCompanionBuilder,
          $$ReadingSettingsTableUpdateCompanionBuilder,
          (
            ReadingSetting,
            BaseReferences<
              _$ReadingDatabase,
              $ReadingSettingsTable,
              ReadingSetting
            >,
          ),
          ReadingSetting,
          PrefetchHooks Function()
        > {
  $$ReadingSettingsTableTableManager(
    _$ReadingDatabase db,
    $ReadingSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> fontSize = const Value.absent(),
          }) => ReadingSettingsCompanion(id: id, fontSize: fontSize),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> fontSize = const Value.absent(),
          }) => ReadingSettingsCompanion.insert(id: id, fontSize: fontSize),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$ReadingDatabase,
      $ReadingSettingsTable,
      ReadingSetting,
      $$ReadingSettingsTableFilterComposer,
      $$ReadingSettingsTableOrderingComposer,
      $$ReadingSettingsTableAnnotationComposer,
      $$ReadingSettingsTableCreateCompanionBuilder,
      $$ReadingSettingsTableUpdateCompanionBuilder,
      (
        ReadingSetting,
        BaseReferences<
          _$ReadingDatabase,
          $ReadingSettingsTable,
          ReadingSetting
        >,
      ),
      ReadingSetting,
      PrefetchHooks Function()
    >;

class $ReadingDatabaseManager {
  final _$ReadingDatabase _db;
  $ReadingDatabaseManager(this._db);
  $$VersesTableTableManager get verses =>
      $$VersesTableTableManager(_db, _db.verses);
  $$ReadingProgressTableTableManager get readingProgress =>
      $$ReadingProgressTableTableManager(_db, _db.readingProgress);
  $$ReadingSettingsTableTableManager get readingSettings =>
      $$ReadingSettingsTableTableManager(_db, _db.readingSettings);
}
