import 'package:sqflite/sqflite.dart';

import '../../features/auth/models/local_account.dart';
import '../../features/diet/models/diet_enums.dart';
import '../../features/diet/models/user_profile.dart';
import '../db/app_database.dart';

/// Reads/writes the single-row `profile` table (id is always 1 — this app
/// has exactly one local account, never a multi-user table).
class ProfileRepository {
  ProfileRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<LocalAccount?> getAccount() async {
    final db = await _database.database;
    final rows = await db.query('profile', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<void> saveAccount(LocalAccount account) async {
    final db = await _database.database;
    await db.insert('profile', _toRow(account), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clear() async {
    final db = await _database.database;
    await db.delete('profile', where: 'id = 1');
  }

  Map<String, Object?> _toRow(LocalAccount account) {
    final metrics = account.bodyMetrics;
    return {
      'id': 1,
      'name': account.name,
      'email': account.email,
      'password_hash': account.passwordHash,
      'sex': metrics.sex.name,
      'age_years': metrics.ageYears,
      'height_cm': metrics.heightCm,
      'weight_kg': metrics.weightKg,
      'activity_level': metrics.activityLevel.name,
      'goal': metrics.goal.name,
      'units': account.units.name,
      'onboarding_complete': account.onboardingComplete ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  LocalAccount _fromRow(Map<String, Object?> row) {
    final metrics = UserProfile(
      sex: BiologicalSex.values.byName(row['sex']! as String),
      ageYears: row['age_years']! as int,
      heightCm: (row['height_cm']! as num).toDouble(),
      weightKg: (row['weight_kg']! as num).toDouble(),
      activityLevel: ActivityLevel.values.byName(row['activity_level']! as String),
      goal: DietGoal.values.byName(row['goal']! as String),
    );
    return LocalAccount(
      name: row['name']! as String,
      email: row['email']! as String,
      passwordHash: row['password_hash']! as String,
      bodyMetrics: metrics,
      units: Units.values.byName(row['units']! as String),
      onboardingComplete: (row['onboarding_complete']! as int) == 1,
    );
  }
}
