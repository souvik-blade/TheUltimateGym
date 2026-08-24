import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../theme/app_colors.dart';

/// Shared "nothing here yet" placeholder — used by tabs/lists before any
/// real data exists, so every empty state in the app looks the same.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(icon, color: AppColors.orange, size: 28),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

/// Convenience default icon for empty states that don't need a specific one.
const IconData emptyStateDefaultIcon = PhosphorIconsRegular.tray;
