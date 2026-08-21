import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/app_colors.dart';
import '../models/exercise.dart';

/// Three-tier image resolution for an exercise:
/// 1. Bundled local asset, if this exercise is one of the 21 curated ones.
/// 2. Network fetch from the free-exercise-db raw GitHub URL, for any of
///    the other ~850 exercises that have an `images` entry.
/// 3. A graceful placeholder icon, for the handful with no images at all.
class ExerciseImage extends StatelessWidget {
  const ExerciseImage({
    super.key,
    required this.exercise,
    required this.isCurated,
    this.imageIndex = 0,
    this.fit = BoxFit.cover,
  });

  final Exercise exercise;
  final bool isCurated;
  final int imageIndex;
  final BoxFit fit;

  static const _networkBase =
      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/';

  @override
  Widget build(BuildContext context) {
    if (exercise.images.isEmpty || imageIndex >= exercise.images.length) {
      return _Placeholder();
    }
    final relativePath = exercise.images[imageIndex];

    if (isCurated) {
      return Image.asset(
        'assets/images/exercises/$relativePath',
        fit: fit,
        errorBuilder: (_, _, _) => _Placeholder(),
      );
    }

    return CachedNetworkImage(
      imageUrl: '$_networkBase$relativePath',
      fit: fit,
      placeholder: (_, _) => const _Loading(),
      errorWidget: (_, _, _) => _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.glassFill,
      alignment: Alignment.center,
      child: const Icon(
        PhosphorIconsRegular.image,
        color: AppColors.textSecondary,
        size: 32,
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.glassFill,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.orange),
      ),
    );
  }
}
