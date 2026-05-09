import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/presentation/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:agri/modules/device_model/data/model/device_module.dart';

class DeviceOverviewWidget extends StatelessWidget {
  final DeviceModule? activeModule;
  const DeviceOverviewWidget({super.key, required this.activeModule});

  @override
  Widget build(BuildContext context) {
    if (activeModule == null) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsManager.black,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        spacing: 24,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Module Overview',
                  style: TextStylesManager.white.white20w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: ColorsManager.textTextGrey,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: activeModule!.isActive == true
                            ? ColorsManager.lightGreen
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      activeModule!.isActive == true ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: activeModule!.isActive == true
                            ? ColorsManager.lightGreen
                            : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (activeModule!.nickname != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                activeModule!.nickname!,
                style: TextStyle(
                  color: ColorsManager.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Module Location',
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${activeModule!.locationLat ?? 0.0}, ${activeModule!.locationLng ?? 0.0}',
                      style: const TextStyle(
                        color: ColorsManager.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Module ID',
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      activeModule!.moduleCode ?? 'Unknown',
                      style: const TextStyle(
                        color: ColorsManager.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Last Update',
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      activeModule!.lastSeenAt?.toSmartString() ?? 'Never',
                      style: const TextStyle(
                        color: ColorsManager.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Update Interval',
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Every ${activeModule!.updateIntervalSec ?? 0} sec',
                      style: const TextStyle(
                        color: ColorsManager.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => RouteManager.goTo(RouteManager.liveFeed),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: ColorsManager.lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_rounded, color: ColorsManager.black),
                  SizedBox(width: 8),
                  Text(
                    'View Live Stream',
                    style: TextStyle(
                      color: ColorsManager.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
