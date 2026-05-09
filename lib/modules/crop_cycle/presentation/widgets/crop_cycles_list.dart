import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri/notifiers.dart';
import '../../data/models/crop_cycle.dart';
import '../screens/add_crop_cycle_screen.dart';
import 'crop_card.dart';

class CropCyclesList extends ConsumerWidget {
  final List<CropCycle> cropCycles;

  const CropCyclesList({super.key, required this.cropCycles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: cropCycles.length,
      itemBuilder: (context, index) {
        return CropCard(
          crop: cropCycles[index],
          onDelete: () {
            ref.read(cropCycleProvider.notifier).deleteCropCycle(cropCycles[index].id);
          },
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddCropCycleScreen(cropCycle: cropCycles[index]),
              ),
            );
          },
        );
      },
    );
  }
}
