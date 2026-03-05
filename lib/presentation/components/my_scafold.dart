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
  requsets(
    activeIcon: IconsaxPlusBold.document_text_1,
    inactiveIcon: IconsaxPlusLinear.document_text,
  ),
  wallet(
    activeIcon: IconsaxPlusBold.empty_wallet,
    inactiveIcon: IconsaxPlusLinear.empty_wallet,
  ),
  profile(
    activeIcon: IconsaxPlusBold.profile,
    inactiveIcon: IconsaxPlusLinear.profile,
  );

  final IconData activeIcon;
  final IconData inactiveIcon;

  const HomePages({required this.activeIcon, required this.inactiveIcon});

  String get title {
    // final apploc = getappLoc();
    switch (this) {
      case HomePages.home:
        return 'home';
      case HomePages.requsets:
        return 'requests';
      case HomePages.wallet:
        return 'wallet';
      case HomePages.profile:
        return 'profile';
    }
  }
}

class MyScafold extends HookConsumerWidget {
  const MyScafold({super.key, required this.screens});
  final List<Widget> screens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(layoutProvider);
    final notifier = ref.read(layoutProvider.notifier);

    return Scaffold(
      backgroundColor: ColorsManager.primary,
      body: LazyLoadIndexedStack(index: page.index, children: screens),
      // bottomNavigationBar: CustomBottomNavBar(
      //   currentIndex: page.index,
      //   onTap: (int e) {
      //     notifier.state = HomePages.values[e];
      //   },
      // ),
    );
  }
}
