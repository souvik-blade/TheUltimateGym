import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/glass_card.dart';
import '../auth/models/local_account.dart';
import '../auth/state/profile_controller.dart';
import '../auth/widgets/body_metrics_form.dart';
import 'credits_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editBodyMetrics(BuildContext context, LocalAccount account) async {
    final formKey = GlobalKey<BodyMetricsFormState>();
    final textTheme = Theme.of(context).textTheme;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.92,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundAlt,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Edit body metrics', style: textTheme.titleLarge),
                      const SizedBox(height: 16),
                      BodyMetricsForm(
                        key: formKey,
                        initial: account.bodyMetrics,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final metrics = formKey.currentState?.validateAndBuild();
                            if (metrics == null) return;
                            sheetContext.read<ProfileController>().updateBodyMetrics(metrics);
                            Navigator.of(sheetContext).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _confirmResetData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundAlt,
        title: const Text('Reset app data?'),
        content: const Text(
          'This permanently deletes your local profile and all data on '
          'this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ProfileController>().resetAppData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final account = context.watch<ProfileController>().account;

    if (account == null) {
      return const SizedBox.shrink();
    }

    final metrics = account.bodyMetrics;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile', style: textTheme.displayLarge),
                const SizedBox(height: 24),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.orangeGradient,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          account.name.isNotEmpty
                              ? account.name[0].toUpperCase()
                              : '?',
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(account.name, style: textTheme.titleLarge),
                            const SizedBox(height: 2),
                            Text(account.email, style: textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Body metrics', style: textTheme.titleLarge),
                          TextButton(
                            onPressed: () => _editBodyMetrics(context, account),
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _MetricRow(label: 'Sex', value: _capitalize(metrics.sex.name)),
                      _MetricRow(label: 'Age', value: '${metrics.ageYears} yrs'),
                      _MetricRow(
                        label: 'Height',
                        value: '${metrics.heightCm.toStringAsFixed(0)} cm',
                      ),
                      _MetricRow(
                        label: 'Weight',
                        value: '${metrics.weightKg.toStringAsFixed(1)} kg',
                      ),
                      _MetricRow(
                        label: 'Activity',
                        value: metrics.activityLevel.label,
                      ),
                      _MetricRow(label: 'Goal', value: metrics.goal.label),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          PhosphorIconsRegular.certificate,
                          color: AppColors.orange,
                        ),
                        title: const Text('Credits'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CreditsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: AppColors.glassBorder),
                      ListTile(
                        leading: const Icon(
                          PhosphorIconsRegular.signOut,
                          color: AppColors.orange,
                        ),
                        title: const Text('Log out'),
                        onTap: () => context.read<ProfileController>().logout(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  border: Colors.redAccent.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Danger zone',
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Permanently delete your profile and all data on '
                        'this device.',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                        onPressed: () => _confirmResetData(context),
                        child: const Text('Reset app data'),
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

String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyMedium),
          Text(value, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
