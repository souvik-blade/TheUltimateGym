import 'package:fitness_pro/data/db/app_database.dart';
import 'package:fitness_pro/data/repositories/profile_repository.dart';
import 'package:fitness_pro/features/auth/models/local_account.dart';
import 'package:fitness_pro/features/diet/models/diet_enums.dart';
import 'package:fitness_pro/features/diet/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers/in_memory_db.dart';

void main() {
  setUp(() async {
    await setUpInMemoryDatabase();
  });

  tearDown(() async {
    await AppDatabase.instance.close();
  });

  test('getAccount returns null before anything is saved', () async {
    final repo = ProfileRepository();
    expect(await repo.getAccount(), isNull);
  });

  test('saveAccount then getAccount round-trips every field', () async {
    final repo = ProfileRepository();
    final account = LocalAccount(
      name: 'Jamie',
      email: 'jamie@example.com',
      passwordHash: 'hashed',
      bodyMetrics: const UserProfile(
        sex: BiologicalSex.female,
        ageYears: 29,
        heightCm: 168.5,
        weightKg: 61.2,
        activityLevel: ActivityLevel.active,
        goal: DietGoal.cut,
      ),
      units: Units.imperial,
      onboardingComplete: true,
    );

    await repo.saveAccount(account);
    final loaded = await repo.getAccount();

    expect(loaded, isNotNull);
    expect(loaded!.name, 'Jamie');
    expect(loaded.email, 'jamie@example.com');
    expect(loaded.passwordHash, 'hashed');
    expect(loaded.units, Units.imperial);
    expect(loaded.onboardingComplete, isTrue);
    expect(loaded.bodyMetrics.sex, BiologicalSex.female);
    expect(loaded.bodyMetrics.ageYears, 29);
    expect(loaded.bodyMetrics.heightCm, 168.5);
    expect(loaded.bodyMetrics.weightKg, 61.2);
    expect(loaded.bodyMetrics.activityLevel, ActivityLevel.active);
    expect(loaded.bodyMetrics.goal, DietGoal.cut);
  });

  test('saveAccount replaces the single row rather than inserting a second', () async {
    final repo = ProfileRepository();
    const metrics = UserProfile(
      sex: BiologicalSex.male,
      ageYears: 30,
      heightCm: 180,
      weightKg: 80,
      activityLevel: ActivityLevel.moderate,
      goal: DietGoal.maintain,
    );
    await repo.saveAccount(
      LocalAccount(name: 'First', email: 'a@a.com', passwordHash: 'x', bodyMetrics: metrics),
    );
    await repo.saveAccount(
      LocalAccount(name: 'Second', email: 'b@b.com', passwordHash: 'y', bodyMetrics: metrics),
    );

    final loaded = await repo.getAccount();
    expect(loaded!.name, 'Second');
  });

  test('clear removes the account', () async {
    final repo = ProfileRepository();
    const metrics = UserProfile(
      sex: BiologicalSex.other,
      ageYears: 40,
      heightCm: 170,
      weightKg: 70,
      activityLevel: ActivityLevel.sedentary,
      goal: DietGoal.bulk,
    );
    await repo.saveAccount(
      LocalAccount(name: 'Temp', email: 't@t.com', passwordHash: 'z', bodyMetrics: metrics),
    );
    expect(await repo.getAccount(), isNotNull);

    await repo.clear();
    expect(await repo.getAccount(), isNull);
  });
}
