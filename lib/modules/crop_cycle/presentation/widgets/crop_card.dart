import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/crop_cycle.dart';

class CropCard extends StatelessWidget {
  final CropCycle crop;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CropCard({
    super.key,
    required this.crop,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final plantAgeDays = crop.sowingDate != null
        ? DateTime.now().difference(crop.sowingDate!).inDays
        : 0;
    final expectedHarvestFormatted = crop.expectedHarvestDate != null
        ? DateFormat('dd MMM yyyy').format(crop.expectedHarvestDate!)
        : 'N/A';

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: ColorsManager.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    crop.cycleName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white70, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _InfoTile(icon: Icons.straighten, label: 'Area', value: '${crop.growingAreaM2 ?? 0} m²')),
                  const SizedBox(width: 10),
                  Expanded(child: _InfoTile(icon: Icons.eco, label: 'Crop', value: crop.cropName)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _InfoTile(icon: Icons.local_florist, label: 'Plant Age', value: '$plantAgeDays days')),
                  const SizedBox(width: 10),
                  Expanded(child: _InfoTile(icon: Icons.calendar_today, label: 'Expect Harvest', value: expectedHarvestFormatted)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: ColorsManager.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorsManager.lightGreen, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
