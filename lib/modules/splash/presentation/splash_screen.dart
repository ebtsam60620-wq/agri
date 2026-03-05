import 'dart:developer';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/resources/assets.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/loading_state_enum.dart';
import 'package:agri/data/data_sources/localization_local_data_source.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBlueBgColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage(Assets.splashlogo),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          AnimatedLogoSplash(
            width: AppSizeConfig().width,
            isTablet: AppSizeConfig().isTablet,
          ),
        ],
      ),
    );
  }
}

class AnimatedLogoSplash extends StatefulHookConsumerWidget {
  final bool isTablet;
  final double width;

  const AnimatedLogoSplash({
    super.key,
    required this.isTablet,
    required this.width,
  });

  @override
  AnimatedLogoSplashState createState() => AnimatedLogoSplashState();
}

class AnimatedLogoSplashState extends ConsumerState<AnimatedLogoSplash> {
  late AnimationController animationController;
  late final splashNotifier = ref.read(splashProvider.notifier);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
      splashNotifier.initializeApp();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController = useAnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 500),
    );

    ref.listen(splashProvider, (o, current) {
      if (current.loadingState == LoadingStateEnum.success ||
          current.loadingState == LoadingStateEnum.error) {
        Future.delayed(const Duration(seconds: 4), () {
          if (current.user != null) {
            final user = current.user!;
            log(user.toString());
            RouteManager.firstScreen(user: user, goto: false);
          } else {
            final langCode = di<LocalizationLocalDataSource>()
                .getLocalization();
            if (langCode.isFirstTime) {
              RouteManager.replace(RouteManager.onboarding);
            } else {
              RouteManager.replace(RouteManager.login);
            }
          }
        });
      }
    });
    return FadeTransition(
      opacity: animationController,
      child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              Assets.splashLogo,
              height: widget.isTablet ? widget.width * 0.5 : widget.width * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0,
            start: 0,
            child: SvgPicture.asset(Assets.splashLogo2),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            end: 0,
            bottom: widget.isTablet ? widget.width * 0.1 : widget.width * 0.15,
            child: SvgPicture.asset(Assets.splashHand, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
