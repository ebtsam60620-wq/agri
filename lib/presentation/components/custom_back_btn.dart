import 'package:flutter/material.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/presentation/components/my_button.dart';

class CustomBackBtn extends StatelessWidget {
  const CustomBackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onPressed: () => RouteManager.pop(),
      color: Colors.white,
      gradientColors: null,
      childWidget: const Icon(Icons.arrow_back_ios_new),
    );
  }
}
