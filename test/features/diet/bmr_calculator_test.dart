import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_pro/features/diet/bmr_calculator.dart';
import 'package:fitness_pro/features/diet/models/diet_enums.dart';
import 'package:fitness_pro/features/diet/models/user_profile.dart';

void main() {
  group('BmrCalculator.calculateBmr', () {
    test('male: matches Mifflin-St Jeor formula', () {
      final profile = UserProfile(
        sex: BiologicalSex.male,
        ageYears: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.sedentary,
        goal: DietGoal.maintain,
      );
      // 10*80 + 6.25*180 - 5*30 + 5 = 800 + 1125 - 150 + 5 = 1780
      expect(BmrCalculator.calculateBmr(profile), closeTo(1780, 0.01));
    });

    test('female: matches Mifflin-St Jeor formula', () {
      final profile = UserProfile(
        sex: BiologicalSex.female,
        ageYears: 30,
        heightCm: 165,
        weightKg: 60,
        activityLevel: ActivityLevel.sedentary,
        goal: DietGoal.maintain,
      );
      // 10*60 + 6.25*165 - 5*30 - 161 = 600 + 1031.25 - 150 - 161 = 1320.25
      expect(BmrCalculator.calculateBmr(profile), closeTo(1320.25, 0.01));
    });

    test('other: averages the male/female constants', () {
      final male = UserProfile(
        sex: BiologicalSex.male,
        ageYears: 25,
        heightCm: 170,
        weightKg: 70,
        activityLevel: ActivityLevel.sedentary,
        goal: DietGoal.maintain,
      );
      final other = male.copyWith(sex: BiologicalSex.other);
      final female = male.copyWith(sex: BiologicalSex.female);

      final bmrOther = BmrCalculator.calculateBmr(other);
      final expected =
          (BmrCalculator.calculateBmr(male) +
              BmrCalculator.calculateBmr(female)) /
          2;
      expect(bmrOther, closeTo(expected, 0.01));
    });
  });

  group('BmrCalculator.calculateTdee', () {
    test('applies the activity multiplier', () {
      expect(
        BmrCalculator.calculateTdee(1500, ActivityLevel.sedentary),
        closeTo(1800, 0.01),
      );
      expect(
        BmrCalculator.calculateTdee(1500, ActivityLevel.veryActive),
        closeTo(2850, 0.01),
      );
    });
  });

  group('BmrCalculator.calculateMacroTargets', () {
    final baseProfile = UserProfile(
      sex: BiologicalSex.male,
      ageYears: 28,
      heightCm: 178,
      weightKg: 75,
      activityLevel: ActivityLevel.moderate,
      goal: DietGoal.maintain,
    );

    test('maintain: calorie target equals TDEE', () {
      final result = BmrCalculator.calculateMacroTargets(baseProfile);
      expect(result.calorieTarget, closeTo(result.tdee, 0.01));
    });

    test('cut: calorie target is below TDEE but never below BMR', () {
      final cutProfile = baseProfile.copyWith(goal: DietGoal.cut);
      final result = BmrCalculator.calculateMacroTargets(cutProfile);
      expect(result.calorieTarget, lessThan(result.tdee));
      expect(
        result.calorieTarget,
        greaterThanOrEqualTo(result.bmr - 0.01),
      );
    });

    test('bulk: calorie target is above TDEE', () {
      final bulkProfile = baseProfile.copyWith(goal: DietGoal.bulk);
      final result = BmrCalculator.calculateMacroTargets(bulkProfile);
      expect(result.calorieTarget, greaterThan(result.tdee));
    });

    test('macro kcal roughly reconstructs the calorie target', () {
      final result = BmrCalculator.calculateMacroTargets(baseProfile);
      final macroKcal =
          result.proteinKcal + result.carbsKcal + result.fatKcal;
      expect(macroKcal, closeTo(result.calorieTarget, 1));
    });

    test('extreme cut deficit never drives calories below BMR', () {
      // A tiny sedentary TDEE close to BMR should still clamp correctly.
      final tinyProfile = UserProfile(
        sex: BiologicalSex.female,
        ageYears: 70,
        heightCm: 150,
        weightKg: 45,
        activityLevel: ActivityLevel.sedentary,
        goal: DietGoal.cut,
      );
      final result = BmrCalculator.calculateMacroTargets(tinyProfile);
      expect(result.calorieTarget, greaterThanOrEqualTo(result.bmr - 0.01));
    });
  });

  group('UserProfile.isValid', () {
    test('rejects out-of-range values', () {
      final valid = UserProfile(
        sex: BiologicalSex.male,
        ageYears: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderate,
        goal: DietGoal.maintain,
      );
      expect(valid.isValid, isTrue);
      expect(valid.copyWith(ageYears: 0).isValid, isFalse);
      expect(valid.copyWith(heightCm: 0).isValid, isFalse);
      expect(valid.copyWith(weightKg: 600).isValid, isFalse);
    });
  });
}
