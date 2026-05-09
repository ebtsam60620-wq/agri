import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_scafold.dart';
import 'package:agri/core/configs/colors_manager.dart';

class CustomBackBtn extends ConsumerWidget {
  const CustomBackBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyButton(
      onPressed: () {
        if (RouteManager.canPop(context: context)) {
          RouteManager.pop();
        } else if (context.getRouteSettings().name == RouteManager.home) {
          // If we are on Home but can't pop, reset the layout state
          ref.read(layoutProvider.notifier).update((state) => HomePages.home);
        }
      },
      borderColor: ColorsManager.textWhite,
      color: ColorsManager.white,
      borderWidth: 2,
      margin: const EdgeInsets.all(0),
      // If MyButton has width/height parameters, you can set them here for a perfect square/circle (e.g., width: 44, height: 44)
      childWidget: const Center(
        child: Icon(
          // Corrected directional logic: LTR points left, RTL points right
          Icons.arrow_back_ios_new,
          color: ColorsManager.black,
          size: 18,
        ),
      ),
    );
  }
}
