import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../data/repositories/exercise_repository.dart';
import '../../theme/app_colors.dart';
import '../../widgets/empty_state.dart';
import 'exercise_detail_screen.dart';
import 'models/exercise.dart';
import 'widgets/exercise_image.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final _repo = ExerciseRepository.instance;
  final _searchController = TextEditingController();

  List<Exercise> _all = [];
  Set<String> _curatedIds = {};
  List<String> _categories = [];
  String? _selectedCategory;
  String _query = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  Future<void> _load() async {
    final all = await _repo.loadAll();
    final curated = await _repo.curatedIds();
    final categories = await _repo.distinctCategories();
    if (!mounted) return;
    setState(() {
      _all = all;
      _curatedIds = curated;
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> get _filtered {
    final q = _query.trim().toLowerCase();
    return _all.where((ex) {
      if (q.isNotEmpty && !ex.name.toLowerCase().contains(q)) return false;
      if (_selectedCategory != null && ex.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orange),
      );
    }

    final filtered = _filtered;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search exercises',
              prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass),
              filled: true,
              fillColor: AppColors.glassFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _CategoryChip(
                label: 'All',
                selected: _selectedCategory == null,
                onTap: () => setState(() => _selectedCategory = null),
              ),
              for (final category in _categories)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _CategoryChip(
                    label: category,
                    selected: _selectedCategory == category,
                    onTap: () => setState(() => _selectedCategory = category),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyState(
                  icon: PhosphorIconsRegular.magnifyingGlass,
                  title: 'No matches',
                  message: 'Try a different search or category.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final exercise = filtered[index];
                    return _ExerciseRow(
                      exercise: exercise,
                      isCurated: _curatedIds.contains(exercise.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : AppColors.glassFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.orange : AppColors.glassBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label[0].toUpperCase() + label.substring(1),
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({required this.exercise, required this.isCurated});

  final Exercise exercise;
  final bool isCurated;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtitleParts = [
      exercise.category,
      if (exercise.equipment != null) exercise.equipment!,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ExerciseDetailScreen(
                  exercise: exercise,
                  isCurated: isCurated,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: ExerciseImage(
                      exercise: exercise,
                      isCurated: isCurated,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleParts.join(' • '),
                        style: textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
