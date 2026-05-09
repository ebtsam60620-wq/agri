import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:agri/presentation/components/custom_back_btn.dart';

class CropCyclesHeader extends StatelessWidget {
  final int count;

  const CropCyclesHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          const CustomBackBtn(),
          const SizedBox(width: 12),
          const Text(
            'Crop Cycles',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: ColorsManager.textBlack,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorsManager.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count Active',
              style: const TextStyle(
                color: ColorsManager.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
