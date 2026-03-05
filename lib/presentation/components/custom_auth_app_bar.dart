import 'package:flutter/material.dart';

import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/textstyles.dart';

class CustomAuthAppBar extends StatelessWidget {
  final String title;
  const CustomAuthAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        // Back button
        MyButton(
          onPressed: () => RouteManager.pop(),
          color: Colors.white,
          gradientColors: null,
          childWidget: const Icon(Icons.arrow_back_ios_new),
        ),
        // Title text centered
        Expanded(
          child: Center(
            child: Text(title, style: TextStylesManager.black.black24wBold),
          ),
        ),
        // Placeholder to balance the back button
        const SizedBox(width: 48),
      ],
    );
  }
}
