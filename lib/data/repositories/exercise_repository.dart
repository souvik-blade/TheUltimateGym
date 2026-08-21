import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../features/exercises/models/exercise.dart';

/// Loads the bundled exercise dataset once and serves it from memory —
/// it's static/read-only, so there's no reason to round-trip it through
/// sqflite. `exercises.json` (873 entries) is the source of truth for
/// browsing; `exercises_curated.json` only tells us which ids have a local
/// image bundled (see [curatedIds]).
class ExerciseRepository {
  ExerciseRepository._();

  static final ExerciseRepository instance = ExerciseRepository._();

  List<Exercise>? _exercises;
  Set<String>? _curatedIds;

  Future<List<Exercise>> loadAll() async {
    final cached = _exercises;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/data/exercises.json');
    final list = json.decode(raw) as List;
    final exercises = list
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
    _exercises = exercises;
    return exercises;
  }

  /// Ids that have a bundled local image under assets/images/exercises/.
  Future<Set<String>> curatedIds() async {
    final cached = _curatedIds;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString(
      'assets/data/exercises_curated.json',
    );
    final list = json.decode(raw) as List;
    final ids = list
        .map((e) => (e as Map<String, dynamic>)['id'] as String)
        .toSet();
    _curatedIds = ids;
    return ids;
  }

  Future<Exercise?> byId(String id) async {
    final all = await loadAll();
    for (final e in all) {
      if (e.id == id) return e;
    }
    return null;
  }

  Future<List<Exercise>> search({
    String query = '',
    String? category,
    String? equipment,
  }) async {
    final all = await loadAll();
    final q = query.trim().toLowerCase();
    return all.where((ex) {
      if (q.isNotEmpty && !ex.name.toLowerCase().contains(q)) return false;
      if (category != null && ex.category != category) return false;
      if (equipment != null && ex.equipment != equipment) return false;
      return true;
    }).toList();
  }

  Future<List<String>> distinctCategories() async {
    final all = await loadAll();
    final categories = all.map((e) => e.category).toSet().toList();
    categories.sort();
    return categories;
  }

  Future<List<String>> distinctEquipment() async {
    final all = await loadAll();
    final equipment = all.map((e) => e.equipment).whereType<String>().toSet().toList();
    equipment.sort();
    return equipment;
  }

  /// Exercises whose `equipment` field exactly matches [equipment].
  Future<List<Exercise>> byEquipment(String equipment) async {
    final all = await loadAll();
    return all.where((e) => e.equipment == equipment).toList();
  }
}
