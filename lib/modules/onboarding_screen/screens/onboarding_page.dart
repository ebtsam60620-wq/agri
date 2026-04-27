import 'package:agri/core/utils/extension_methods.dart';
import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;
  final VoidCallback onSkip;

  const OnboardingPage({
    super.key,
    required this.model,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen background image
        Positioned.fill(
          child: Image.asset(
            model.image,
            fit: BoxFit.cover,
          ),
        ),
        // Dark overlay for better text readability (optional but recommended)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(0.2.toAlpha),
                  Colors.transparent,
                  Colors.black.withAlpha(0.7.toAlpha),
                ],
              ),
            ),
          ),
        ),
        // Skip button at the top
        Positioned(
          top: 60,
          left: 30,
          child: GestureDetector(
            onTap: onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        // Text Content at the bottom
        Positioned(
          bottom: 220,
          left: 30,
          right: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.titlePart1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                model.titlePart2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                model.titlePart3,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
