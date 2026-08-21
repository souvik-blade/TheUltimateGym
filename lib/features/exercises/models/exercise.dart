class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.force,
    required this.level,
    required this.mechanic,
    required this.equipment,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.category,
    required this.images,
  });

  final String id;
  final String name;
  final String? force;
  final String level;
  final String? mechanic;
  final String? equipment;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String category;

  /// Relative paths like "Plank/0.jpg" — not directly usable as an asset or
  /// URL on their own; see ExerciseImage for how these get resolved.
  final List<String> images;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      force: json['force'] as String?,
      level: json['level'] as String? ?? 'beginner',
      mechanic: json['mechanic'] as String?,
      equipment: json['equipment'] as String?,
      primaryMuscles: List<String>.from(
        json['primaryMuscles'] as List? ?? const [],
      ),
      secondaryMuscles: List<String>.from(
        json['secondaryMuscles'] as List? ?? const [],
      ),
      instructions: List<String>.from(
        json['instructions'] as List? ?? const [],
      ),
      category: json['category'] as String? ?? 'strength',
      images: List<String>.from(json['images'] as List? ?? const []),
    );
  }
}
