import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/presentation/components/lazy_animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import 'onboarding_page.dart';
// Ensure you import the file where your LazyAnimatedIndexedStack is defined
// import 'path_to_your_custom_widget.dart';

class OnboardingMainScreen extends StatefulWidget {
  const OnboardingMainScreen({super.key});

  @override
  State<OnboardingMainScreen> createState() => _OnboardingMainScreenState();
}

class _OnboardingMainScreenState extends State<OnboardingMainScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF7DBE25);

    return Scaffold(
      body: Stack(
        children: [
          // Using your custom LazyAnimatedIndexedStack
          LazyAnimatedIndexedStack(
            index: _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // Custom animation builder if you want something other than the default
            animationBuilder: (context, animation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            children: onboardingData.map((data) {
              return OnboardingPage(
                model: data,
                onSkip: () => RouteManager.goTo(RouteManager.welcome),
              );
            }).toList(),
          ),

          // Indicators and Navigation UI
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? primaryGreen
                            : Colors.white.withAlpha(0.3.toAlpha),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Navigation Logic
                if (_currentPage == onboardingData.length - 1)
                  _buildGetStartedButton(primaryGreen)
                else
                  _buildNextButton(primaryGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        onPressed: () {
          RouteManager.goTo(RouteManager.welcome);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPage++;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: const Icon(Icons.arrow_forward, color: Colors.black, size: 30),
      ),
    );
  }
}
