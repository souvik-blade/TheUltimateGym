import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/app_colors.dart';
import '../widgets/app_background.dart';

/// Shown while [ProfileController.initialize] loads the on-device profile.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.orangeGradient),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              PhosphorIconsFill.barbell,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
