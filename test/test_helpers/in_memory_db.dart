import 'package:fitness_pro/data/db/app_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Points [AppDatabase.instance] at a fresh, isolated in-memory database via
/// the ffi sqflite backend — the real on-disk `sqflite` plugin has no
/// platform channel to answer in the plain `flutter_test` VM environment.
/// Call once per test (a new in-memory DB each time — nothing persists
/// between tests, no on-disk file, no cross-test flakiness).
///
/// Uses the *no-isolate* factory deliberately: the isolate-backed
/// `databaseFactoryFfi` dispatches each query through a background isolate,
/// and that cross-isolate message passing doesn't reliably resolve within
/// `tester.pumpAndSettle()`'s frame-scheduling loop — the future ends up
/// completing after the test has already torn down its widget tree.
Future<void> setUpInMemoryDatabase() async {
  // AppTheme.dark pulls Sora/Inter via google_fonts, which fetches over the
  // network at runtime. In the test VM that network call has no real
  // timeout handling and leaves a pending Timer behind after the widget
  // tree is disposed — fall back to the bundled system font instead.
  GoogleFonts.config.allowRuntimeFetching = false;

  sqfliteFfiInit();
  final db = await databaseFactoryFfiNoIsolate.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: AppDatabase.schemaVersion,
      onCreate: (db, version) => AppDatabase.createSchema(db),
    ),
  );
  AppDatabase.instance.setDatabaseForTesting(db);
}
