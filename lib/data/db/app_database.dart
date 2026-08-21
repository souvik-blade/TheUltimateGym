import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Single sqflite connection for the whole app, shared by every repository.
/// The full schema is created up front (v1) even though later phases fill
/// in the workout/food tables — one migration story, no incremental DDL.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const int schemaVersion = 1;

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final dbDir = await getDatabasesPath();
    final path = p.join(dbDir, 'fitness_pro.db');
    return openDatabase(
      path,
      version: schemaVersion,
      onCreate: (db, version) => createSchema(db),
    );
  }

  /// Public so tests can create the same schema on an isolated in-memory
  /// database via `sqflite_common_ffi` instead of touching a real on-disk
  /// file (see [setDatabaseForTesting]).
  static Future<void> createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        sex TEXT NOT NULL,
        age_years INTEGER NOT NULL,
        height_cm REAL NOT NULL,
        weight_kg REAL NOT NULL,
        activity_level TEXT NOT NULL,
        goal TEXT NOT NULL,
        units TEXT NOT NULL DEFAULT 'metric',
        onboarding_complete INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_plan_days (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_id INTEGER NOT NULL REFERENCES workout_plans(id) ON DELETE CASCADE,
        name TEXT NOT NULL,
        sort_order INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_plan_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day_id INTEGER NOT NULL REFERENCES workout_plan_days(id) ON DELETE CASCADE,
        exercise_id TEXT NOT NULL,
        target_sets INTEGER NOT NULL,
        target_reps INTEGER NOT NULL,
        sort_order INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plan_day_id INTEGER REFERENCES workout_plan_days(id) ON DELETE SET NULL,
        date TEXT NOT NULL,
        completed_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_session_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL REFERENCES workout_sessions(id) ON DELETE CASCADE,
        exercise_id TEXT NOT NULL,
        set_number INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight_kg REAL,
        completed_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE food_diary_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_id TEXT NOT NULL,
        date TEXT NOT NULL,
        meal_slot TEXT NOT NULL,
        quantity_grams REAL NOT NULL,
        logged_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE measurements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        weight_kg REAL NOT NULL,
        body_fat_pct REAL,
        notes TEXT
      )
    ''');
  }

  /// Test-only hook: point this instance at an already-open in-memory or
  /// ffi-backed database instead of opening the real on-disk one.
  void setDatabaseForTesting(Database db) {
    _db = db;
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
