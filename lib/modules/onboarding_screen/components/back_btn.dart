import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          color: ColorsManager.textWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
            child: Icon(
          IconsaxPlusLinear.arrow_left,
          color: ColorsManager.textGrey,
        )),
      ),
    );
  }
}
