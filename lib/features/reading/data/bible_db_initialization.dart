import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Switches the app to the local demo asset and its own database (dev only).
const bool _useDemoData = bool.fromEnvironment('USE_DEMO_DATA');
const String _canonicalAssetPath = 'assets/db/bible_prepacked.db';
const String _demoAssetPath = 'assets/db/bible_prepacked_demo.db';
const String _canonicalDatabaseName = 'rv1960';
const String _demoDatabaseName = 'rv1960_demo';

/// Opens the local Bible database, seeding it from the prepackaged asset the
/// first time the app runs.
///
/// Copying a prebuilt SQLite file (a plain byte copy of a few megabytes) is
/// far faster than parsing and inserting the whole RV1960 JSON on the device,
/// which removes the wait on the splash screen. With USE_DEMO_DATA it copies
/// the demo asset and works against a separate database, so the canonical one
/// stays untouched.
QueryExecutor openBibleDatabase() {
  final assetPath = _useDemoData ? _demoAssetPath : _canonicalAssetPath;
  final databaseName = _useDemoData
      ? _demoDatabaseName
      : _canonicalDatabaseName;

  return driftDatabase(
    name: databaseName,
    native: DriftNativeOptions(
      databasePath: () async {
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final file = File(
          '${documentsDirectory.path}${Platform.pathSeparator}'
          '$databaseName.sqlite',
        );

        if (!file.existsSync()) {
          final asset = await _loadAsset(assetPath);
          await file.create(recursive: true);
          await file.writeAsBytes(
            asset.buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes),
            flush: true,
          );
        }

        return file.path;
      },
    ),
  );
}

/// Loads [path] from the bundle. A missing demo asset fails with an actionable
/// message instead of leaving the app stuck on a blank screen.
Future<ByteData> _loadAsset(String path) async {
  try {
    return await rootBundle.load(path);
  } on Object {
    if (_useDemoData) {
      throw StateError(
        'Demo data asset "$_demoAssetPath" is missing. Run '
        '"fvm dart run tool/seed_stats_demo.dart" to generate it.',
      );
    }
    rethrow;
  }
}
