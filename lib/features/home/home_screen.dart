import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/glass_card.dart';
import '../auth/state/profile_controller.dart';
import '../diet/diet_calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final account = context.watch<ProfileController>().account;
    final firstName = account?.name.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back', style: textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(firstName, style: textTheme.displayLarge),
                const SizedBox(height: 32),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.orangeGradient,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          PhosphorIconsFill.lightning,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current streak', style: textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              'Log a workout to start your streak',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Diet program', style: textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Get your daily calorie and macro targets, '
                        'calculated from your own body and activity.',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DietCalculatorScreen(),
                            ),
                          );
                        },
                        child: const Text('Calculate my targets'),
                      ),
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
