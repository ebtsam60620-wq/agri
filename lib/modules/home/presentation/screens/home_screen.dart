import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:agri/presentation/components/my_dropdown.dart';
import 'package:agri/presentation/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:agri/modules/device_model/presentation/componant/device_overview_widget.dart';
import 'package:agri/modules/device_model/data/model/device_module.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(device.notifier).fetchModules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashrepo = ref.watch(splashProvider);
    final deviceState = ref.watch(device);
    final deviceNotifier = ref.read(device.notifier);

    // Prepare dropdown data
    final Map<DeviceModule, dynamic> dropdownData = {
      for (var d in deviceState.devices) d: d.nickname ?? d.moduleCode,
    };
    return SingleChildScrollView(
      child: Column(
        spacing: 25,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${splashrepo.user?.fullName}',
                      style: TextStylesManager.black.black24wBold,
                    ),
                    Text(
                      'Good Morning!',
                      style: TextStylesManager.black.black24wBold,
                    ),
                    Text(
                      DateTime.now().toFormattedString(
                        format: 'EEEE, d MMMM y',
                      ),
                      style: TextStylesManager.black.black16w400,
                    ),
                  ],
                ),
              ),
              MyButton(
                width: 40,
                height: 40,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(5),
                onPressed: () => RouteManager.goTo(RouteManager.alerts),
                color: Colors.black,
                childWidget: Badge(
                  padding: EdgeInsets.all(0),
                  alignment: Alignment.topRight,
                  isLabelVisible: true,
                  child: Icon(
                    IconsaxPlusLinear.notification,
                    color: ColorsManager.white,
                  ),
                ),
              ),
            ],
          ),

          MyTextField(hintText: 'Search Here...'),

          if (dropdownData.isNotEmpty && dropdownData.length > 1)
            MyDropDownTextField<DeviceModule>(
              dataList: dropdownData,
              value: deviceState.activeModule,
              hintText: 'Select Module',
              onChanged: (selected) {
                deviceNotifier.setActiveModule(selected);
              },
            ),

          DeviceOverviewWidget(activeModule: deviceState.activeModule),
        ],
      ),
    );
  }
}
