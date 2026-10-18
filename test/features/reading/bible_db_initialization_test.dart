import 'dart:async' show runZonedGuarded;
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:bibliapp/features/reading/data/bible_db_initialization.dart';
import 'package:bibliapp/features/reading/data/datasources/reading_database.dart';

class _PathProviderStub extends PathProviderPlatform {
  _PathProviderStub(this.documentsPath, this.temporaryPath);

  String documentsPath;
  final String temporaryPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;

  @override
  Future<String?> getTemporaryPath() async => temporaryPath;
}

Future<int> _verseCount(ReadingDatabase database) async {
  final row = await database
      .customSelect('SELECT COUNT(*) AS total FROM verses')
      .getSingle();
  return row.read<int>('total');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late _PathProviderStub pathProvider;
  late PathProviderPlatform originalPathProvider;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    tempDir = await Directory.systemTemp.createTemp('bible_db_init_test');
    final tempCache = Directory('${tempDir.path}/tmp')..createSync();
    pathProvider = _PathProviderStub(tempDir.path, tempCache.path);
    originalPathProvider = PathProviderPlatform.instance;
    PathProviderPlatform.instance = pathProvider;
  });

  tearDown(() {
    PathProviderPlatform.instance = originalPathProvider;
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  File copiedDatabase() =>
      File('${tempDir.path}${Platform.pathSeparator}rv1960.sqlite');

  test(
    'copies the prepacked asset on the first run and serves verses',
    () async {
      final database = ReadingDatabase(executor: openBibleDatabase());
      addTearDown(database.close);

      final total = await _verseCount(database);

      expect(total, greaterThan(0));
      expect(copiedDatabase().existsSync(), isTrue);
      expect(copiedDatabase().lengthSync(), greaterThan(0));
    },
  );

  test('does not overwrite an existing database file', () async {
    final first = ReadingDatabase(executor: openBibleDatabase());
    final total = await _verseCount(first);
    expect(total, greaterThan(0));
    await first.close();

    // Any re-copy would restore a working database; a healthy second open
    // over this corrupted file would mean the asset was copied again.
    copiedDatabase().writeAsStringSync('not a database');

    final second = ReadingDatabase(executor: openBibleDatabase());
    addTearDown(second.close);
    await expectLater(_verseCount(second), throwsA(anything));
  });

  test('retries successfully after a failed first attempt', () async {
    // The documents path sits under a regular file, so creating the database
    // path fails and the first attempt never copies the asset. The failure is
    // delivered both through the query future and as a stray async error from
    // drift's connection future, so the first attempt runs in a guarded zone.
    final blocker = File('${tempDir.path}${Platform.pathSeparator}blocker')
      ..writeAsStringSync('x');
    pathProvider.documentsPath = '${blocker.path}/docs';

    await runZonedGuarded(
      () async {
        final failing = ReadingDatabase(executor: openBibleDatabase());
        await expectLater(_verseCount(failing), throwsA(anything));
        try {
          await failing.close();
        } on Object {
          // Closing a database that never opened rethrows the original error.
        }
      },
      (error, stack) {
        // Swallow the stray connection error from the failed first attempt.
      },
    );
    expect(copiedDatabase().existsSync(), isFalse);

    // With a writable path the retry copies the prepacked database.
    pathProvider.documentsPath = tempDir.path;
    final retried = ReadingDatabase(executor: openBibleDatabase());
    addTearDown(retried.close);

    expect(await _verseCount(retried), greaterThan(0));
    expect(copiedDatabase().existsSync(), isTrue);
  });
}
