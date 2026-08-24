import 'package:flutter/material.dart';

import '../../data/repositories/exercise_repository.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/empty_state.dart';
import '../exercises/exercise_detail_screen.dart';
import '../exercises/models/exercise.dart';
import '../exercises/widgets/exercise_image.dart';
import 'equipment_mapping.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class EquipmentDetailScreen extends StatefulWidget {
  const EquipmentDetailScreen({super.key, required this.item});

  final EquipmentItem item;

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  List<Exercise> _matches = [];
  Set<String> _curatedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ExerciseRepository.instance;
    final seen = <String>{};
    final matches = <Exercise>[];
    for (final tag in widget.item.equipmentTags) {
      for (final ex in await repo.byEquipment(tag)) {
        if (seen.add(ex.id)) matches.add(ex);
      }
    }
    final curated = await repo.curatedIds();
    if (!mounted) return;
    setState(() {
      _matches = matches;
      _curatedIds = curated;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(widget.item.displayName)),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.glassFill,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(widget.item.imagePath, fit: BoxFit.contain),
                ),
                const SizedBox(height: 24),
                Text('Exercises using this', style: textTheme.titleLarge),
                const SizedBox(height: 12),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.orange),
                    ),
                  )
                else if (_matches.isEmpty)
                  const EmptyState(
                    icon: PhosphorIconsRegular.info,
                    title: 'No matched exercises yet',
                    message: 'Browse the exercise library to find movements '
                        'that use this equipment.',
                  )
                else
                  for (final exercise in _matches.take(15))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ExerciseDetailScreen(
                                  exercise: exercise,
                                  isCurated: _curatedIds.contains(exercise.id),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.glassFill,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: ExerciseImage(
                                      exercise: exercise,
                                      isCurated: _curatedIds.contains(exercise.id),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    exercise.name,
                                    style: textTheme.bodyLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
