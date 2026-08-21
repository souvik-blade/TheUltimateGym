import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/glass_card.dart';
import 'models/exercise.dart';
import 'widgets/exercise_image.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    required this.isCurated,
  });

  final Exercise exercise;
  final bool isCurated;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muscles = [
      ...exercise.primaryMuscles,
      ...exercise.secondaryMuscles,
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(exercise.name)),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ExerciseImage(exercise: exercise, isCurated: isCurated),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(label: exercise.category),
                    _Tag(label: exercise.level),
                    if (exercise.equipment != null) _Tag(label: exercise.equipment!),
                    if (exercise.force != null) _Tag(label: exercise.force!),
                  ],
                ),
                if (muscles.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('Muscles worked', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(muscles.join(', '), style: textTheme.bodyMedium),
                ],
                if (exercise.instructions.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('How to perform it', style: textTheme.titleLarge),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < exercise.instructions.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i == exercise.instructions.length - 1 ? 0 : 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  margin: const EdgeInsets.only(top: 1),
                                  decoration: const BoxDecoration(
                                    color: AppColors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${i + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    exercise.instructions[i],
                                    style: textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }
}
