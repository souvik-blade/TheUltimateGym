import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../widgets/app_background.dart';
import '../../widgets/empty_state.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Text('Workouts', style: textTheme.displayLarge),
              ),
              const Expanded(
                child: EmptyState(
                  icon: PhosphorIconsRegular.barbell,
                  title: 'No workout plans yet',
                  message:
                      'Build a plan from the exercise library and log your '
                      'sessions to start tracking progress.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
