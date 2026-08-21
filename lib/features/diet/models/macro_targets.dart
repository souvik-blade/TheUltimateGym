/// Computed daily energy and macro targets for a [UserProfile].
class MacroTargets {
  const MacroTargets({
    required this.bmr,
    required this.tdee,
    required this.calorieTarget,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  /// Basal metabolic rate — calories burned at rest.
  final double bmr;

  /// Total daily energy expenditure — BMR scaled by activity level.
  final double tdee;

  /// Daily calorie target after applying the goal's surplus/deficit.
  final double calorieTarget;

  final double proteinG;
  final double carbsG;
  final double fatG;

  double get proteinKcal => proteinG * 4;
  double get carbsKcal => carbsG * 4;
  double get fatKcal => fatG * 9;
}
