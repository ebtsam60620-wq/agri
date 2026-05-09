import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/modules/device_model/presentation/componant/device_overview_widget.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/custom_back_btn.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevicesListScreen extends ConsumerWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesState = ref.watch(device);
    final modules = devicesState.devices;

    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const SizedBox(width: 50, height: 50, child: CustomBackBtn()),
              const SizedBox(height: 24),
              MyButton(
                color: ColorsManager.secondary,
                onPressed: () =>
                    RouteManager.goTo(RouteManager.addDeviceScreen),
                childWidget: Text(
                  'Add Model',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: modules.isEmpty
                    ? const Center(child: Text('No modules linked yet.'))
                    : ListView.builder(
                        itemCount: modules.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DeviceOverviewWidget(
                              activeModule: modules[index],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddModuleButton extends StatelessWidget {
  const AddModuleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to scan or add screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFF4C8D66,
          ), // Green color from screenshot
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Add Module',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
