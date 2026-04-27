import 'package:agri/core/configs/my_flutter_app_icons.dart';
import 'package:agri/modules/home/presentation/screens/home_screen.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:agri/presentation/components/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:agri/core/configs/colors_manager.dart';
// import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/notifiers.dart';

enum HomePages {
  home(
    activeIcon: IconsaxPlusBold.home_2,
    inactiveIcon: IconsaxPlusLinear.home_2,
  ),
  cropCycle(
    activeIcon: IconsaxPlusBold.additem,
    inactiveIcon: IconsaxPlusLinear.additem,
  ),
  scan(activeIcon: IconsaxPlusBold.scan, inactiveIcon: IconsaxPlusLinear.scan),
  sensors(
    activeIcon: MyFlutterAppIcons.carbonTempreture,
    inactiveIcon: MyFlutterAppIcons.carbonTempreture,
  ),
  settings(
    activeIcon: IconsaxPlusBold.setting,
    inactiveIcon: IconsaxPlusLinear.setting,
  );

  final IconData activeIcon;
  final IconData inactiveIcon;

  const HomePages({required this.activeIcon, required this.inactiveIcon});
}

class MyScafold extends HookConsumerWidget {
  const MyScafold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(layoutProvider);
    final notifier = ref.read(layoutProvider.notifier);
    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: AppSizeConfig().topViewPadding + 20,
              right: 15,
              left: 15,
            ),
            child: LazyLoadIndexedStack(
              index: page.index,
              children: [
                HomeScreen(),
                Container(),
                Container(),
                Container(),
                Container(),
              ],
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: SizedBox(
              height: 100,
              child: CustomBottomNavBar(
                currentIndex: page,
                onTap: (HomePages e) {
                  notifier.state = e;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
