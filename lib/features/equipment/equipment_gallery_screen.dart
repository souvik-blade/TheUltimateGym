import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'equipment_detail_screen.dart';
import 'equipment_mapping.dart';

class EquipmentGalleryScreen extends StatelessWidget {
  const EquipmentGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: equipmentCatalog.length,
      itemBuilder: (context, index) {
        final item = equipmentCatalog[index];
        return _EquipmentTile(item: item);
      },
    );
  }
}

class _EquipmentTile extends StatelessWidget {
  const _EquipmentTile({required this.item});

  final EquipmentItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EquipmentDetailScreen(item: item),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(item.imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                item.displayName,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
