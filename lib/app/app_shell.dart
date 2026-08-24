import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../features/diet/diet_calculator_screen.dart';
import '../features/home/home_screen.dart';
import '../features/library/library_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/workout/workout_list_screen.dart';
import '../widgets/glass_nav_bar.dart';

/// Root app shell once a profile exists and is signed in: 5 tabs kept alive
/// via IndexedStack, detail screens push over the top via the single outer
/// Navigator (a deliberate simplification over per-tab nested Navigators —
/// this app's scale doesn't need per-tab back-stacks).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    WorkoutListScreen(),
    LibraryScreen(),
    DietCalculatorScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: GlassNavBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.house),
            selectedIcon: Icon(PhosphorIconsFill.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.barbell),
            selectedIcon: Icon(PhosphorIconsFill.barbell),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.bookOpen),
            selectedIcon: Icon(PhosphorIconsFill.bookOpen),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.forkKnife),
            selectedIcon: Icon(PhosphorIconsFill.forkKnife),
            label: 'Diet',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsRegular.user),
            selectedIcon: Icon(PhosphorIconsFill.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
