import 'dart:developer';

import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agri/modules/device_model/presentation/componant/name_device_dialog.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_snackbar.dart';

class AddDeviceScreen extends HookConsumerWidget {
  const AddDeviceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moduleIDController = useTextEditingController();
    return AuthScaffold(
      step: 2,
      title: 'Connect Your Agaro\n module',
      subTitle: 'Choose Your Preferred Connection Method',
      onNext: () {
        if (moduleIDController.text.isNotEmpty) {
          NameDeviceDialog.show(context, moduleIDController.text);
        } else {
          mySnackBar("Please enter or scan a Module ID", context);
        }
      },
      uiNext: 'Continue',
      bottomSubTitle: 'Don’t have a module ID?',
      bottomSubEnd: 'Contact Support',
      onSub: () {},
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MyTextField(
            controller: moduleIDController,
            titleText: 'Agaro Module ID',
            hintText: 'Agaro Module ID',
          ),
          MyButton(
            onPressed: () async {
              final url = await RouteManager.goTo(RouteManager.scanCodeScreen);
              if (url is String && url.isNotEmpty) {
                if (context.mounted) {
                  NameDeviceDialog.show(context, url);
                }
              }
            },
            color: ColorsManager.lightGreen,
            radius: 20,
            padding: const EdgeInsets.all(20),
            expandWidth: true,
            height: 160,
            childWidget: SizedBox(
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(IconsaxPlusBold.scan, size: 72),
                  Text('Scan QR Code'),
                  Text('Use camera to scan module QR'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
