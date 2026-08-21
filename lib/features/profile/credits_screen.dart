import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../widgets/app_background.dart';
import '../../widgets/glass_card.dart';

/// Required attribution for third-party assets — see
/// assets/data/ASSET_ATTRIBUTION.md. Exercise data (free-exercise-db) is
/// public domain and needs no credit; these two do.
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Credits')),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nutrition data & photos', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        '© Open Food Facts contributors. Database under the '
                        'Open Database License (ODbL); images under '
                        'CC BY-SA.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('3D equipment renders', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        '"Low Poly Gym Set" by VNB-Leo, used under '
                        'CC BY 4.0.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exercise library', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'free-exercise-db by yuhonas — public domain '
                        '(Unlicense).',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final info = snapshot.data;
                    return Text(
                      info == null
                          ? ' '
                          : 'Fitness Pro ${info.version} (${info.buildNumber})',
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
