import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';

class MySwitcher extends StatelessWidget {
  const MySwitcher({
    super.key,
    required this.valueNotifier,
    this.width = 45,
    this.height = 24,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.borderRadius = 20,
    this.duration = const Duration(milliseconds: 300),
  });

  final ValueNotifier<bool> valueNotifier;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double borderRadius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        return GestureDetector(
          onTap: () {
            valueNotifier.value = !value;
          },
          child: AnimatedContainer(
            duration: duration,
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: value
                  ? activeColor ?? ColorsManager.primary
                  : inactiveColor ?? ColorsManager.greyE0E0E0,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: height - 8, // Thumb size based on height
              height: height - 8,
              decoration: BoxDecoration(
                color: thumbColor ?? ColorsManager.textWhite,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
