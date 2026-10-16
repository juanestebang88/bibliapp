import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const String _prepackedAssetPath = 'assets/db/bible_prepacked.db';
const String _databaseName = 'rv1960';

/// Opens the local Bible database, seeding it from the prepackaged asset the
/// first time the app runs.
///
/// Copying a prebuilt SQLite file (a plain byte copy of a few megabytes) is
/// far faster than parsing and inserting the whole RV1960 JSON on the device,
/// which removes the wait on the splash screen.
QueryExecutor openBibleDatabase() {
  return driftDatabase(
    name: _databaseName,
    native: DriftNativeOptions(
      databasePath: () async {
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final file = File(
          '${documentsDirectory.path}${Platform.pathSeparator}'
          '$_databaseName.sqlite',
        );

        if (!file.existsSync()) {
          final asset = await rootBundle.load(_prepackedAssetPath);
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
