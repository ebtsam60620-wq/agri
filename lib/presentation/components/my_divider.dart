import 'package:flutter/material.dart';
import 'package:agri/presentation/app_size_config.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
    this.width,
    this.height,
    this.radius,
    required this.color,
  });
  final double? width, height, radius;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: width ?? AppSizeConfig().width,
      height: height ?? 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius ?? 2),
      ),
    );
  }
}
