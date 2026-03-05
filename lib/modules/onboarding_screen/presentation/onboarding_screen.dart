import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:agri/presentation/components/navigation_row.dart';
import 'package:agri/presentation/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:iconsax_plus/iconsax_plus.dart';

class OnboardingScreen extends HookWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentPage = useValueNotifier(0);

    final onboardingData = [
      {
        'title': " AppLocalizations.of(context).onboarding_1_title",
        'description': "AppLocalizations.of(context).onboarding_1_description",
      },
      {
        'title': "AppLocalizations.of(context).onboarding_2_title",
        'description': "AppLocalizations.of(context).onboarding_2_description",
      },
      {
        'title': " AppLocalizations.of(context).onboarding_3_title",
        'description': " AppLocalizations.of(context).onboarding_3_description",
      },
    ];

    void nextPage() {
      if (currentPage.value < onboardingData.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      } else {
        RouteManager.replaceUntilOrAll(RouteManager.selectUserType);
      }
    }

    void previousPage() {
      if (currentPage.value > 0) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }

    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBlueBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: AppSizeConfig().topViewPadding + 15),
            ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, value, _) {
                if (value == 2) {
                  return const SizedBox.shrink();
                }
                return Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => RouteManager.replaceUntilOrAll(
                      RouteManager.selectUserType,
                    ),
                    child: Text(
                      "  AppLocalizations.of(context).skip",
                      style: TextStylesManager.grey7D7D7D20w500,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SvgPicture.asset(
                          'assets/images/onboarding_${index + 1}.svg',
                        ),
                      ),
                      const SizedBox(height: 50),
                      Flexible(
                        flex: 1,
                        child: Text(
                          data['title']!,
                          textAlign: TextAlign.center,
                          style: TextStylesManager.blue.largeTitle,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        data['description']!,
                        textAlign: TextAlign.center,
                        style: TextStylesManager.black.black14w500,
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, value, _) {
                return Column(
                  children: [
                    NavigationRow(
                      prevIcon: currentPage.value > 0
                          ? IconsaxPlusLinear.arrow_left
                          : null,
                      nextIcon: currentPage.value == onboardingData.length - 1
                          ? IconsaxPlusLinear.arrow_right
                          : null,
                      nextTitle: currentPage.value == onboardingData.length - 1
                          ? "get_started"
                          : "next",
                      onPrev: currentPage.value > 0 ? previousPage : null,
                      onNext: nextPage,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(4.0),
                          width: value == index ? 25 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: value == index
                                ? ColorsManager.primary
                                : ColorsManager.iconsLightGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
