import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.orangeGradient,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    PhosphorIconsFill.barbell,
                    color: Colors.white,
                    size: 40,
                  ),
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 32),
                Text(
                  'Fitness Pro',
                  style: textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                const SizedBox(height: 12),
                Text(
                  'Workouts, equipment guidance, and a diet plan\n'
                  'built around your own body — not a generic template.',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text('Get Started'),
                  ),
                ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
                const SizedBox(height: 12),
                Text(
                  'Your data stays on this device.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
