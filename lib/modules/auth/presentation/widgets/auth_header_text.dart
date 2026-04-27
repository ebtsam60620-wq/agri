import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/textstyles.dart';

class AuthHeaderText extends StatelessWidget {
  const AuthHeaderText({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStylesManager.black.black24wBold.copyWith(fontSize: 32),
        ),
        Text(
          subtitle,
          style: TextStylesManager.black.black18w500.copyWith(
            fontSize: 14,
            color: ColorsManager.textGrey,
          ),
        ),
      ],
    );
  }
}
