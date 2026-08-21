import 'diet_enums.dart';

/// Inputs to the BMR/TDEE calculation. Weight/height are stored in metric
/// units (kg, cm) since the Mifflin-St Jeor formula is defined in metric.
class UserProfile {
  const UserProfile({
    required this.sex,
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    required this.goal,
  });

  final BiologicalSex sex;
  final int ageYears;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activityLevel;
  final DietGoal goal;

  bool get isValid =>
      ageYears > 0 &&
      ageYears < 120 &&
      heightCm > 0 &&
      heightCm < 300 &&
      weightKg > 0 &&
      weightKg < 500;

  UserProfile copyWith({
    BiologicalSex? sex,
    int? ageYears,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    DietGoal? goal,
  }) {
    return UserProfile(
      sex: sex ?? this.sex,
      ageYears: ageYears ?? this.ageYears,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }
}
