import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../equipment/equipment_gallery_screen.dart';
import '../exercises/exercise_library_screen.dart';

/// Hosts Exercises and Equipment as an internal TabBar rather than two
/// separate bottom-nav items, so the main nav bar stays at 5 destinations.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Text('Library', style: textTheme.displayLarge),
                ),
                const SizedBox(height: 12),
                TabBar(
                  labelColor: AppColors.orange,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.orange,
                  tabs: const [
                    Tab(text: 'Exercises'),
                    Tab(text: 'Equipment'),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      ExerciseLibraryScreen(),
                      EquipmentGalleryScreen(),
                    ],
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
