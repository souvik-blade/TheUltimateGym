import 'models/diet_enums.dart';
import 'models/macro_targets.dart';
import 'models/user_profile.dart';

/// BMR via the Mifflin-St Jeor equation, TDEE via activity multiplier, and
/// daily macro targets from the user's goal. Pure functions, no I/O — keeps
/// this testable and reusable regardless of how the UI collects input.
class BmrCalculator {
  const BmrCalculator._();

  static const double _cutCalorieDeficit = 500;
  static const double _bulkCalorieSurplus = 300;

  static double calculateBmr(UserProfile profile) {
    final base =
        10 * profile.weightKg + 6.25 * profile.heightCm - 5 * profile.ageYears;
    return switch (profile.sex) {
      BiologicalSex.male => base + 5,
      BiologicalSex.female => base - 161,
      // Average of the male (+5) and female (-161) constants.
      BiologicalSex.other => base - 78,
    };
  }

  static double calculateTdee(double bmr, ActivityLevel activityLevel) {
    return bmr * activityLevel.multiplier;
  }

  static MacroTargets calculateMacroTargets(UserProfile profile) {
    final bmr = calculateBmr(profile);
    final tdee = calculateTdee(bmr, profile.activityLevel);

    final calorieTarget = switch (profile.goal) {
      // Never target below BMR — that's an unsafe deficit.
      DietGoal.cut => (tdee - _cutCalorieDeficit).clamp(bmr, tdee),
      DietGoal.maintain => tdee,
      DietGoal.bulk => tdee + _bulkCalorieSurplus,
    };

    final proteinPerKg = switch (profile.goal) {
      DietGoal.cut => 2.2,
      DietGoal.maintain => 1.8,
      DietGoal.bulk => 2.0,
    };
    final proteinG = proteinPerKg * profile.weightKg;
    final fatG = (calorieTarget * 0.25) / 9;
    final remainingKcal =
        (calorieTarget - proteinG * 4 - fatG * 9).clamp(0, double.infinity);
    final carbsG = remainingKcal / 4;

    return MacroTargets(
      bmr: bmr,
      tdee: tdee,
      calorieTarget: calorieTarget.toDouble(),
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    );
  }
}
