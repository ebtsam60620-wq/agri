import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';

class CropCyclesEmpty extends StatelessWidget {
  const CropCyclesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorsManager.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.grass, color: ColorsManager.primary, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'No crops yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ColorsManager.textBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first crop cycle to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
