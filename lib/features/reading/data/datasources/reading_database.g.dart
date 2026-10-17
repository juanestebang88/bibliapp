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
  @override
  List<GeneratedColumn> get $columns => [id, lastBook, lastChapter];
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
  const ReadingProgressData({
    required this.id,
    required this.lastBook,
    required this.lastChapter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_book'] = Variable<String>(lastBook);
    map['last_chapter'] = Variable<int>(lastChapter);
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      id: Value(id),
      lastBook: Value(lastBook),
      lastChapter: Value(lastChapter),
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
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastBook': serializer.toJson<String>(lastBook),
      'lastChapter': serializer.toJson<int>(lastChapter),
    };
  }

  ReadingProgressData copyWith({int? id, String? lastBook, int? lastChapter}) =>
      ReadingProgressData(
        id: id ?? this.id,
        lastBook: lastBook ?? this.lastBook,
        lastChapter: lastChapter ?? this.lastChapter,
      );
  ReadingProgressData copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressData(
      id: data.id.present ? data.id.value : this.id,
      lastBook: data.lastBook.present ? data.lastBook.value : this.lastBook,
      lastChapter: data.lastChapter.present
          ? data.lastChapter.value
          : this.lastChapter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressData(')
          ..write('id: $id, ')
          ..write('lastBook: $lastBook, ')
          ..write('lastChapter: $lastChapter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastBook, lastChapter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressData &&
          other.id == this.id &&
          other.lastBook == this.lastBook &&
          other.lastChapter == this.lastChapter);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressData> {
  final Value<int> id;
  final Value<String> lastBook;
  final Value<int> lastChapter;
  const ReadingProgressCompanion({
    this.id = const Value.absent(),
    this.lastBook = const Value.absent(),
    this.lastChapter = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    this.id = const Value.absent(),
    required String lastBook,
    required int lastChapter,
  }) : lastBook = Value(lastBook),
       lastChapter = Value(lastChapter);
  static Insertable<ReadingProgressData> custom({
    Expression<int>? id,
    Expression<String>? lastBook,
    Expression<int>? lastChapter,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastBook != null) 'last_book': lastBook,
      if (lastChapter != null) 'last_chapter': lastChapter,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<int>? id,
    Value<String>? lastBook,
    Value<int>? lastChapter,
  }) {
    return ReadingProgressCompanion(
      id: id ?? this.id,
      lastBook: lastBook ?? this.lastBook,
      lastChapter: lastChapter ?? this.lastChapter,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('id: $id, ')
          ..write('lastBook: $lastBook, ')
          ..write('lastChapter: $lastChapter')
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

class $ChapterProgressTable extends ChapterProgress
    with TableInfo<$ChapterProgressTable, ChapterProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterProgressTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _lastVerseReadMeta = const VerificationMeta(
    'lastVerseRead',
  );
  @override
  late final GeneratedColumn<int> lastVerseRead = GeneratedColumn<int>(
    'last_verse_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompleteMeta = const VerificationMeta(
    'isComplete',
  );
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
    'is_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    book,
    chapter,
    lastVerseRead,
    isComplete,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapter_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterProgressData> instance, {
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
    if (data.containsKey('last_verse_read')) {
      context.handle(
        _lastVerseReadMeta,
        lastVerseRead.isAcceptableOrUnknown(
          data['last_verse_read']!,
          _lastVerseReadMeta,
        ),
      );
    }
    if (data.containsKey('is_complete')) {
      context.handle(
        _isCompleteMeta,
        isComplete.isAcceptableOrUnknown(data['is_complete']!, _isCompleteMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {book, chapter};
  @override
  ChapterProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterProgressData(
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      lastVerseRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_verse_read'],
      )!,
      isComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_complete'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $ChapterProgressTable createAlias(String alias) {
    return $ChapterProgressTable(attachedDatabase, alias);
  }
}

class ChapterProgressData extends DataClass
    implements Insertable<ChapterProgressData> {
  final String book;
  final int chapter;
  final int lastVerseRead;
  final bool isComplete;
  final int? completedAt;
  const ChapterProgressData({
    required this.book,
    required this.chapter,
    required this.lastVerseRead,
    required this.isComplete,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['last_verse_read'] = Variable<int>(lastVerseRead);
    map['is_complete'] = Variable<bool>(isComplete);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    return map;
  }

  ChapterProgressCompanion toCompanion(bool nullToAbsent) {
    return ChapterProgressCompanion(
      book: Value(book),
      chapter: Value(chapter),
      lastVerseRead: Value(lastVerseRead),
      isComplete: Value(isComplete),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory ChapterProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterProgressData(
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      lastVerseRead: serializer.fromJson<int>(json['lastVerseRead']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'lastVerseRead': serializer.toJson<int>(lastVerseRead),
      'isComplete': serializer.toJson<bool>(isComplete),
      'completedAt': serializer.toJson<int?>(completedAt),
    };
  }

  ChapterProgressData copyWith({
    String? book,
    int? chapter,
    int? lastVerseRead,
    bool? isComplete,
    Value<int?> completedAt = const Value.absent(),
  }) => ChapterProgressData(
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    lastVerseRead: lastVerseRead ?? this.lastVerseRead,
    isComplete: isComplete ?? this.isComplete,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  ChapterProgressData copyWithCompanion(ChapterProgressCompanion data) {
    return ChapterProgressData(
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      lastVerseRead: data.lastVerseRead.present
          ? data.lastVerseRead.value
          : this.lastVerseRead,
      isComplete: data.isComplete.present
          ? data.isComplete.value
          : this.isComplete,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterProgressData(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('lastVerseRead: $lastVerseRead, ')
          ..write('isComplete: $isComplete, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(book, chapter, lastVerseRead, isComplete, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterProgressData &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.lastVerseRead == this.lastVerseRead &&
          other.isComplete == this.isComplete &&
          other.completedAt == this.completedAt);
}

class ChapterProgressCompanion extends UpdateCompanion<ChapterProgressData> {
  final Value<String> book;
  final Value<int> chapter;
  final Value<int> lastVerseRead;
  final Value<bool> isComplete;
  final Value<int?> completedAt;
  final Value<int> rowid;
  const ChapterProgressCompanion({
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.lastVerseRead = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChapterProgressCompanion.insert({
    required String book,
    required int chapter,
    this.lastVerseRead = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : book = Value(book),
       chapter = Value(chapter);
  static Insertable<ChapterProgressData> custom({
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? lastVerseRead,
    Expression<bool>? isComplete,
    Expression<int>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (lastVerseRead != null) 'last_verse_read': lastVerseRead,
      if (isComplete != null) 'is_complete': isComplete,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChapterProgressCompanion copyWith({
    Value<String>? book,
    Value<int>? chapter,
    Value<int>? lastVerseRead,
    Value<bool>? isComplete,
    Value<int?>? completedAt,
    Value<int>? rowid,
  }) {
    return ChapterProgressCompanion(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      lastVerseRead: lastVerseRead ?? this.lastVerseRead,
      isComplete: isComplete ?? this.isComplete,
      completedAt: completedAt ?? this.completedAt,
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
    if (lastVerseRead.present) {
      map['last_verse_read'] = Variable<int>(lastVerseRead.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterProgressCompanion(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('lastVerseRead: $lastVerseRead, ')
          ..write('isComplete: $isComplete, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VerseHighlightsTable extends VerseHighlights
    with TableInfo<$VerseHighlightsTable, VerseHighlight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerseHighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
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
  static const VerificationMeta _startOffsetMeta = const VerificationMeta(
    'startOffset',
  );
  @override
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
    'start_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endOffsetMeta = const VerificationMeta(
    'endOffset',
  );
  @override
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
    'end_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorKeyMeta = const VerificationMeta(
    'colorKey',
  );
  @override
  late final GeneratedColumn<String> colorKey = GeneratedColumn<String>(
    'color_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    book,
    chapter,
    verse,
    startOffset,
    endOffset,
    colorKey,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_highlights';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerseHighlight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
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
    if (data.containsKey('start_offset')) {
      context.handle(
        _startOffsetMeta,
        startOffset.isAcceptableOrUnknown(
          data['start_offset']!,
          _startOffsetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startOffsetMeta);
    }
    if (data.containsKey('end_offset')) {
      context.handle(
        _endOffsetMeta,
        endOffset.isAcceptableOrUnknown(data['end_offset']!, _endOffsetMeta),
      );
    } else if (isInserting) {
      context.missing(_endOffsetMeta);
    }
    if (data.containsKey('color_key')) {
      context.handle(
        _colorKeyMeta,
        colorKey.isAcceptableOrUnknown(data['color_key']!, _colorKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_colorKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VerseHighlight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseHighlight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
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
      startOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_offset'],
      )!,
      endOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_offset'],
      )!,
      colorKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VerseHighlightsTable createAlias(String alias) {
    return $VerseHighlightsTable(attachedDatabase, alias);
  }
}

class VerseHighlight extends DataClass implements Insertable<VerseHighlight> {
  final int id;
  final String book;
  final int chapter;
  final int verse;
  final int startOffset;
  final int endOffset;
  final String colorKey;
  final int createdAt;
  final int updatedAt;
  const VerseHighlight({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.startOffset,
    required this.endOffset,
    required this.colorKey,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['start_offset'] = Variable<int>(startOffset);
    map['end_offset'] = Variable<int>(endOffset);
    map['color_key'] = Variable<String>(colorKey);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  VerseHighlightsCompanion toCompanion(bool nullToAbsent) {
    return VerseHighlightsCompanion(
      id: Value(id),
      book: Value(book),
      chapter: Value(chapter),
      verse: Value(verse),
      startOffset: Value(startOffset),
      endOffset: Value(endOffset),
      colorKey: Value(colorKey),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VerseHighlight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseHighlight(
      id: serializer.fromJson<int>(json['id']),
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      startOffset: serializer.fromJson<int>(json['startOffset']),
      endOffset: serializer.fromJson<int>(json['endOffset']),
      colorKey: serializer.fromJson<String>(json['colorKey']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'startOffset': serializer.toJson<int>(startOffset),
      'endOffset': serializer.toJson<int>(endOffset),
      'colorKey': serializer.toJson<String>(colorKey),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  VerseHighlight copyWith({
    int? id,
    String? book,
    int? chapter,
    int? verse,
    int? startOffset,
    int? endOffset,
    String? colorKey,
    int? createdAt,
    int? updatedAt,
  }) => VerseHighlight(
    id: id ?? this.id,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    startOffset: startOffset ?? this.startOffset,
    endOffset: endOffset ?? this.endOffset,
    colorKey: colorKey ?? this.colorKey,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VerseHighlight copyWithCompanion(VerseHighlightsCompanion data) {
    return VerseHighlight(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      startOffset: data.startOffset.present
          ? data.startOffset.value
          : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      colorKey: data.colorKey.present ? data.colorKey.value : this.colorKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseHighlight(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('colorKey: $colorKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    book,
    chapter,
    verse,
    startOffset,
    endOffset,
    colorKey,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseHighlight &&
          other.id == this.id &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.colorKey == this.colorKey &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VerseHighlightsCompanion extends UpdateCompanion<VerseHighlight> {
  final Value<int> id;
  final Value<String> book;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<int> startOffset;
  final Value<int> endOffset;
  final Value<String> colorKey;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const VerseHighlightsCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VerseHighlightsCompanion.insert({
    this.id = const Value.absent(),
    required String book,
    required int chapter,
    required int verse,
    required int startOffset,
    required int endOffset,
    required String colorKey,
    required int createdAt,
    required int updatedAt,
  }) : book = Value(book),
       chapter = Value(chapter),
       verse = Value(verse),
       startOffset = Value(startOffset),
       endOffset = Value(endOffset),
       colorKey = Value(colorKey),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VerseHighlight> custom({
    Expression<int>? id,
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<String>? colorKey,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (startOffset != null) 'start_offset': startOffset,
      if (endOffset != null) 'end_offset': endOffset,
      if (colorKey != null) 'color_key': colorKey,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VerseHighlightsCompanion copyWith({
    Value<int>? id,
    Value<String>? book,
    Value<int>? chapter,
    Value<int>? verse,
    Value<int>? startOffset,
    Value<int>? endOffset,
    Value<String>? colorKey,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return VerseHighlightsCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      colorKey: colorKey ?? this.colorKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (startOffset.present) {
      map['start_offset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['end_offset'] = Variable<int>(endOffset.value);
    }
    if (colorKey.present) {
      map['color_key'] = Variable<String>(colorKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseHighlightsCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('colorKey: $colorKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyVersesTable extends DailyVerses
    with TableInfo<$DailyVersesTable, DailyVerse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyVersesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  @override
  List<GeneratedColumn> get $columns => [id, day, book, chapter, verse];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyVerse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyVerse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyVerse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
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
    );
  }

  @override
  $DailyVersesTable createAlias(String alias) {
    return $DailyVersesTable(attachedDatabase, alias);
  }
}

class DailyVerse extends DataClass implements Insertable<DailyVerse> {
  final int id;

  /// Local date the verse was picked for ('yyyy-MM-dd').
  final String day;
  final String book;
  final int chapter;
  final int verse;
  const DailyVerse({
    required this.id,
    required this.day,
    required this.book,
    required this.chapter,
    required this.verse,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    return map;
  }

  DailyVersesCompanion toCompanion(bool nullToAbsent) {
    return DailyVersesCompanion(
      id: Value(id),
      day: Value(day),
      book: Value(book),
      chapter: Value(chapter),
      verse: Value(verse),
    );
  }

  factory DailyVerse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyVerse(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
    };
  }

  DailyVerse copyWith({
    int? id,
    String? day,
    String? book,
    int? chapter,
    int? verse,
  }) => DailyVerse(
    id: id ?? this.id,
    day: day ?? this.day,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
  );
  DailyVerse copyWithCompanion(DailyVersesCompanion data) {
    return DailyVerse(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyVerse(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, day, book, chapter, verse);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyVerse &&
          other.id == this.id &&
          other.day == this.day &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse);
}

class DailyVersesCompanion extends UpdateCompanion<DailyVerse> {
  final Value<int> id;
  final Value<String> day;
  final Value<String> book;
  final Value<int> chapter;
  final Value<int> verse;
  const DailyVersesCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
  });
  DailyVersesCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required String book,
    required int chapter,
    required int verse,
  }) : day = Value(day),
       book = Value(book),
       chapter = Value(chapter),
       verse = Value(verse);
  static Insertable<DailyVerse> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
    });
  }

  DailyVersesCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<String>? book,
    Value<int>? chapter,
    Value<int>? verse,
  }) {
    return DailyVersesCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyVersesCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse')
          ..write(')'))
        .toString();
  }
}

class $ReadingEventsTable extends ReadingEvents
    with TableInfo<$ReadingEventsTable, ReadingEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activityDateMeta = const VerificationMeta(
    'activityDate',
  );
  @override
  late final GeneratedColumn<String> activityDate = GeneratedColumn<String>(
    'activity_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  @override
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    activityDate,
    book,
    chapter,
    verseCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activity_date')) {
      context.handle(
        _activityDateMeta,
        activityDate.isAcceptableOrUnknown(
          data['activity_date']!,
          _activityDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityDateMeta);
    }
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
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    } else if (isInserting) {
      context.missing(_verseCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {activityDate, book, chapter};
  @override
  ReadingEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingEvent(
      activityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_date'],
      )!,
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
    );
  }

  @override
  $ReadingEventsTable createAlias(String alias) {
    return $ReadingEventsTable(attachedDatabase, alias);
  }
}

class ReadingEvent extends DataClass implements Insertable<ReadingEvent> {
  /// Local date of the day the reading was marked ('yyyy-MM-dd').
  final String activityDate;
  final String book;
  final int chapter;

  /// Verses marked for this chapter that day (max kept on upsert).
  final int verseCount;
  const ReadingEvent({
    required this.activityDate,
    required this.book,
    required this.chapter,
    required this.verseCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_date'] = Variable<String>(activityDate);
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse_count'] = Variable<int>(verseCount);
    return map;
  }

  ReadingEventsCompanion toCompanion(bool nullToAbsent) {
    return ReadingEventsCompanion(
      activityDate: Value(activityDate),
      book: Value(book),
      chapter: Value(chapter),
      verseCount: Value(verseCount),
    );
  }

  factory ReadingEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingEvent(
      activityDate: serializer.fromJson<String>(json['activityDate']),
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verseCount: serializer.fromJson<int>(json['verseCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityDate': serializer.toJson<String>(activityDate),
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verseCount': serializer.toJson<int>(verseCount),
    };
  }

  ReadingEvent copyWith({
    String? activityDate,
    String? book,
    int? chapter,
    int? verseCount,
  }) => ReadingEvent(
    activityDate: activityDate ?? this.activityDate,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verseCount: verseCount ?? this.verseCount,
  );
  ReadingEvent copyWithCompanion(ReadingEventsCompanion data) {
    return ReadingEvent(
      activityDate: data.activityDate.present
          ? data.activityDate.value
          : this.activityDate,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingEvent(')
          ..write('activityDate: $activityDate, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityDate, book, chapter, verseCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingEvent &&
          other.activityDate == this.activityDate &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verseCount == this.verseCount);
}

class ReadingEventsCompanion extends UpdateCompanion<ReadingEvent> {
  final Value<String> activityDate;
  final Value<String> book;
  final Value<int> chapter;
  final Value<int> verseCount;
  final Value<int> rowid;
  const ReadingEventsCompanion({
    this.activityDate = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verseCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingEventsCompanion.insert({
    required String activityDate,
    required String book,
    required int chapter,
    required int verseCount,
    this.rowid = const Value.absent(),
  }) : activityDate = Value(activityDate),
       book = Value(book),
       chapter = Value(chapter),
       verseCount = Value(verseCount);
  static Insertable<ReadingEvent> custom({
    Expression<String>? activityDate,
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? verseCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activityDate != null) 'activity_date': activityDate,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verseCount != null) 'verse_count': verseCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingEventsCompanion copyWith({
    Value<String>? activityDate,
    Value<String>? book,
    Value<int>? chapter,
    Value<int>? verseCount,
    Value<int>? rowid,
  }) {
    return ReadingEventsCompanion(
      activityDate: activityDate ?? this.activityDate,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verseCount: verseCount ?? this.verseCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityDate.present) {
      map['activity_date'] = Variable<String>(activityDate.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingEventsCompanion(')
          ..write('activityDate: $activityDate, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verseCount: $verseCount, ')
          ..write('rowid: $rowid')
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
  late final $ChapterProgressTable chapterProgress = $ChapterProgressTable(
    this,
  );
  late final $VerseHighlightsTable verseHighlights = $VerseHighlightsTable(
    this,
  );
  late final $DailyVersesTable dailyVerses = $DailyVersesTable(this);
  late final $ReadingEventsTable readingEvents = $ReadingEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    verses,
    readingProgress,
    readingSettings,
    chapterProgress,
    verseHighlights,
    dailyVerses,
    readingEvents,
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
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<int> id,
      Value<String> lastBook,
      Value<int> lastChapter,
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
              }) => ReadingProgressCompanion(
                id: id,
                lastBook: lastBook,
                lastChapter: lastChapter,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String lastBook,
                required int lastChapter,
              }) => ReadingProgressCompanion.insert(
                id: id,
                lastBook: lastBook,
                lastChapter: lastChapter,
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
typedef $$ChapterProgressTableCreateCompanionBuilder =
    ChapterProgressCompanion Function({
      required String book,
      required int chapter,
      Value<int> lastVerseRead,
      Value<bool> isComplete,
      Value<int?> completedAt,
      Value<int> rowid,
    });
typedef $$ChapterProgressTableUpdateCompanionBuilder =
    ChapterProgressCompanion Function({
      Value<String> book,
      Value<int> chapter,
      Value<int> lastVerseRead,
      Value<bool> isComplete,
      Value<int?> completedAt,
      Value<int> rowid,
    });

class $$ChapterProgressTableFilterComposer
    extends Composer<_$ReadingDatabase, $ChapterProgressTable> {
  $$ChapterProgressTableFilterComposer({
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

  ColumnFilters<int> get lastVerseRead => $composableBuilder(
    column: $table.lastVerseRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChapterProgressTableOrderingComposer
    extends Composer<_$ReadingDatabase, $ChapterProgressTable> {
  $$ChapterProgressTableOrderingComposer({
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

  ColumnOrderings<int> get lastVerseRead => $composableBuilder(
    column: $table.lastVerseRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChapterProgressTableAnnotationComposer
    extends Composer<_$ReadingDatabase, $ChapterProgressTable> {
  $$ChapterProgressTableAnnotationComposer({
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

  GeneratedColumn<int> get lastVerseRead => $composableBuilder(
    column: $table.lastVerseRead,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$ChapterProgressTableTableManager
    extends
        RootTableManager<
          _$ReadingDatabase,
          $ChapterProgressTable,
          ChapterProgressData,
          $$ChapterProgressTableFilterComposer,
          $$ChapterProgressTableOrderingComposer,
          $$ChapterProgressTableAnnotationComposer,
          $$ChapterProgressTableCreateCompanionBuilder,
          $$ChapterProgressTableUpdateCompanionBuilder,
          (
            ChapterProgressData,
            BaseReferences<
              _$ReadingDatabase,
              $ChapterProgressTable,
              ChapterProgressData
            >,
          ),
          ChapterProgressData,
          PrefetchHooks Function()
        > {
  $$ChapterProgressTableTableManager(
    _$ReadingDatabase db,
    $ChapterProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> lastVerseRead = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChapterProgressCompanion(
                book: book,
                chapter: chapter,
                lastVerseRead: lastVerseRead,
                isComplete: isComplete,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String book,
                required int chapter,
                Value<int> lastVerseRead = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChapterProgressCompanion.insert(
                book: book,
                chapter: chapter,
                lastVerseRead: lastVerseRead,
                isComplete: isComplete,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChapterProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$ReadingDatabase,
      $ChapterProgressTable,
      ChapterProgressData,
      $$ChapterProgressTableFilterComposer,
      $$ChapterProgressTableOrderingComposer,
      $$ChapterProgressTableAnnotationComposer,
      $$ChapterProgressTableCreateCompanionBuilder,
      $$ChapterProgressTableUpdateCompanionBuilder,
      (
        ChapterProgressData,
        BaseReferences<
          _$ReadingDatabase,
          $ChapterProgressTable,
          ChapterProgressData
        >,
      ),
      ChapterProgressData,
      PrefetchHooks Function()
    >;
typedef $$VerseHighlightsTableCreateCompanionBuilder =
    VerseHighlightsCompanion Function({
      Value<int> id,
      required String book,
      required int chapter,
      required int verse,
      required int startOffset,
      required int endOffset,
      required String colorKey,
      required int createdAt,
      required int updatedAt,
    });
typedef $$VerseHighlightsTableUpdateCompanionBuilder =
    VerseHighlightsCompanion Function({
      Value<int> id,
      Value<String> book,
      Value<int> chapter,
      Value<int> verse,
      Value<int> startOffset,
      Value<int> endOffset,
      Value<String> colorKey,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$VerseHighlightsTableFilterComposer
    extends Composer<_$ReadingDatabase, $VerseHighlightsTable> {
  $$VerseHighlightsTableFilterComposer({
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

  ColumnFilters<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VerseHighlightsTableOrderingComposer
    extends Composer<_$ReadingDatabase, $VerseHighlightsTable> {
  $$VerseHighlightsTableOrderingComposer({
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

  ColumnOrderings<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VerseHighlightsTableAnnotationComposer
    extends Composer<_$ReadingDatabase, $VerseHighlightsTable> {
  $$VerseHighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<String> get colorKey =>
      $composableBuilder(column: $table.colorKey, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VerseHighlightsTableTableManager
    extends
        RootTableManager<
          _$ReadingDatabase,
          $VerseHighlightsTable,
          VerseHighlight,
          $$VerseHighlightsTableFilterComposer,
          $$VerseHighlightsTableOrderingComposer,
          $$VerseHighlightsTableAnnotationComposer,
          $$VerseHighlightsTableCreateCompanionBuilder,
          $$VerseHighlightsTableUpdateCompanionBuilder,
          (
            VerseHighlight,
            BaseReferences<
              _$ReadingDatabase,
              $VerseHighlightsTable,
              VerseHighlight
            >,
          ),
          VerseHighlight,
          PrefetchHooks Function()
        > {
  $$VerseHighlightsTableTableManager(
    _$ReadingDatabase db,
    $VerseHighlightsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerseHighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerseHighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerseHighlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<int> startOffset = const Value.absent(),
                Value<int> endOffset = const Value.absent(),
                Value<String> colorKey = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => VerseHighlightsCompanion(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                startOffset: startOffset,
                endOffset: endOffset,
                colorKey: colorKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String book,
                required int chapter,
                required int verse,
                required int startOffset,
                required int endOffset,
                required String colorKey,
                required int createdAt,
                required int updatedAt,
              }) => VerseHighlightsCompanion.insert(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                startOffset: startOffset,
                endOffset: endOffset,
                colorKey: colorKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VerseHighlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$ReadingDatabase,
      $VerseHighlightsTable,
      VerseHighlight,
      $$VerseHighlightsTableFilterComposer,
      $$VerseHighlightsTableOrderingComposer,
      $$VerseHighlightsTableAnnotationComposer,
      $$VerseHighlightsTableCreateCompanionBuilder,
      $$VerseHighlightsTableUpdateCompanionBuilder,
      (
        VerseHighlight,
        BaseReferences<
          _$ReadingDatabase,
          $VerseHighlightsTable,
          VerseHighlight
        >,
      ),
      VerseHighlight,
      PrefetchHooks Function()
    >;
typedef $$DailyVersesTableCreateCompanionBuilder =
    DailyVersesCompanion Function({
      Value<int> id,
      required String day,
      required String book,
      required int chapter,
      required int verse,
    });
typedef $$DailyVersesTableUpdateCompanionBuilder =
    DailyVersesCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<String> book,
      Value<int> chapter,
      Value<int> verse,
    });

class $$DailyVersesTableFilterComposer
    extends Composer<_$ReadingDatabase, $DailyVersesTable> {
  $$DailyVersesTableFilterComposer({
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

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

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
}

class $$DailyVersesTableOrderingComposer
    extends Composer<_$ReadingDatabase, $DailyVersesTable> {
  $$DailyVersesTableOrderingComposer({
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

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

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
}

class $$DailyVersesTableAnnotationComposer
    extends Composer<_$ReadingDatabase, $DailyVersesTable> {
  $$DailyVersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);
}

class $$DailyVersesTableTableManager
    extends
        RootTableManager<
          _$ReadingDatabase,
          $DailyVersesTable,
          DailyVerse,
          $$DailyVersesTableFilterComposer,
          $$DailyVersesTableOrderingComposer,
          $$DailyVersesTableAnnotationComposer,
          $$DailyVersesTableCreateCompanionBuilder,
          $$DailyVersesTableUpdateCompanionBuilder,
          (
            DailyVerse,
            BaseReferences<_$ReadingDatabase, $DailyVersesTable, DailyVerse>,
          ),
          DailyVerse,
          PrefetchHooks Function()
        > {
  $$DailyVersesTableTableManager(_$ReadingDatabase db, $DailyVersesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyVersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyVersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyVersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
              }) => DailyVersesCompanion(
                id: id,
                day: day,
                book: book,
                chapter: chapter,
                verse: verse,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                required String book,
                required int chapter,
                required int verse,
              }) => DailyVersesCompanion.insert(
                id: id,
                day: day,
                book: book,
                chapter: chapter,
                verse: verse,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyVersesTableProcessedTableManager =
    ProcessedTableManager<
      _$ReadingDatabase,
      $DailyVersesTable,
      DailyVerse,
      $$DailyVersesTableFilterComposer,
      $$DailyVersesTableOrderingComposer,
      $$DailyVersesTableAnnotationComposer,
      $$DailyVersesTableCreateCompanionBuilder,
      $$DailyVersesTableUpdateCompanionBuilder,
      (
        DailyVerse,
        BaseReferences<_$ReadingDatabase, $DailyVersesTable, DailyVerse>,
      ),
      DailyVerse,
      PrefetchHooks Function()
    >;
typedef $$ReadingEventsTableCreateCompanionBuilder =
    ReadingEventsCompanion Function({
      required String activityDate,
      required String book,
      required int chapter,
      required int verseCount,
      Value<int> rowid,
    });
typedef $$ReadingEventsTableUpdateCompanionBuilder =
    ReadingEventsCompanion Function({
      Value<String> activityDate,
      Value<String> book,
      Value<int> chapter,
      Value<int> verseCount,
      Value<int> rowid,
    });

class $$ReadingEventsTableFilterComposer
    extends Composer<_$ReadingDatabase, $ReadingEventsTable> {
  $$ReadingEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get activityDate => $composableBuilder(
    column: $table.activityDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingEventsTableOrderingComposer
    extends Composer<_$ReadingDatabase, $ReadingEventsTable> {
  $$ReadingEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get activityDate => $composableBuilder(
    column: $table.activityDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingEventsTableAnnotationComposer
    extends Composer<_$ReadingDatabase, $ReadingEventsTable> {
  $$ReadingEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get activityDate => $composableBuilder(
    column: $table.activityDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );
}

class $$ReadingEventsTableTableManager
    extends
        RootTableManager<
          _$ReadingDatabase,
          $ReadingEventsTable,
          ReadingEvent,
          $$ReadingEventsTableFilterComposer,
          $$ReadingEventsTableOrderingComposer,
          $$ReadingEventsTableAnnotationComposer,
          $$ReadingEventsTableCreateCompanionBuilder,
          $$ReadingEventsTableUpdateCompanionBuilder,
          (
            ReadingEvent,
            BaseReferences<
              _$ReadingDatabase,
              $ReadingEventsTable,
              ReadingEvent
            >,
          ),
          ReadingEvent,
          PrefetchHooks Function()
        > {
  $$ReadingEventsTableTableManager(
    _$ReadingDatabase db,
    $ReadingEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> activityDate = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingEventsCompanion(
                activityDate: activityDate,
                book: book,
                chapter: chapter,
                verseCount: verseCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String activityDate,
                required String book,
                required int chapter,
                required int verseCount,
                Value<int> rowid = const Value.absent(),
              }) => ReadingEventsCompanion.insert(
                activityDate: activityDate,
                book: book,
                chapter: chapter,
                verseCount: verseCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$ReadingDatabase,
      $ReadingEventsTable,
      ReadingEvent,
      $$ReadingEventsTableFilterComposer,
      $$ReadingEventsTableOrderingComposer,
      $$ReadingEventsTableAnnotationComposer,
      $$ReadingEventsTableCreateCompanionBuilder,
      $$ReadingEventsTableUpdateCompanionBuilder,
      (
        ReadingEvent,
        BaseReferences<_$ReadingDatabase, $ReadingEventsTable, ReadingEvent>,
      ),
      ReadingEvent,
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
  $$ChapterProgressTableTableManager get chapterProgress =>
      $$ChapterProgressTableTableManager(_db, _db.chapterProgress);
  $$VerseHighlightsTableTableManager get verseHighlights =>
      $$VerseHighlightsTableTableManager(_db, _db.verseHighlights);
  $$DailyVersesTableTableManager get dailyVerses =>
      $$DailyVersesTableTableManager(_db, _db.dailyVerses);
  $$ReadingEventsTableTableManager get readingEvents =>
      $$ReadingEventsTableTableManager(_db, _db.readingEvents);
}
