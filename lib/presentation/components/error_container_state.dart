import 'package:flutter/material.dart';

import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/textstyles.dart';

class ErrorContainerState extends StatelessWidget {
  const ErrorContainerState({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorsManager.roseFF6262,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            IconsaxPlusBold.close_circle,
            color: ColorsManager.roseFF6262,
            size: 23,
          ),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStylesManager.red.roseFF626216w400,
            ),
          ),
        ],
      ),
    );
  }
}
