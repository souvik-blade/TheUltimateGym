import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Full-screen dark gradient backdrop with soft orange glow blobs,
/// giving glass surfaces placed on top something to refract.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.backgroundGradient,
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: _glowBlob(AppColors.orange.withValues(alpha: 0.35), 260),
        ),
        Positioned(
          bottom: -100,
          left: -80,
          child: _glowBlob(AppColors.orangeSoft.withValues(alpha: 0.2), 300),
        ),
        child,
      ],
    );
  }

  Widget _glowBlob(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
