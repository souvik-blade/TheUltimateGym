/// Biological sex, used only for the Mifflin-St Jeor BMR formula's constant
/// term. [other] averages the male/female constants as a neutral fallback.
enum BiologicalSex { male, female, other }

enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive;

  /// Multiplier applied to BMR to estimate TDEE.
  double get multiplier => switch (this) {
    ActivityLevel.sedentary => 1.2,
    ActivityLevel.light => 1.375,
    ActivityLevel.moderate => 1.55,
    ActivityLevel.active => 1.725,
    ActivityLevel.veryActive => 1.9,
  };

  String get label => switch (this) {
    ActivityLevel.sedentary => 'Sedentary (little or no exercise)',
    ActivityLevel.light => 'Light (exercise 1-3 days/week)',
    ActivityLevel.moderate => 'Moderate (exercise 3-5 days/week)',
    ActivityLevel.active => 'Active (exercise 6-7 days/week)',
    ActivityLevel.veryActive => 'Very active (hard exercise + physical job)',
  };
}

enum DietGoal {
  cut,
  maintain,
  bulk;

  String get label => switch (this) {
    DietGoal.cut => 'Cut (lose fat)',
    DietGoal.maintain => 'Maintain',
    DietGoal.bulk => 'Bulk (gain muscle)',
  };
}
