import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/assets.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/my_scafold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(splashProvider).user;

    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            ProfileHeader(
              name: user?.fullName ?? 'Guest User',
              email: user?.email ?? 'guest@agri.com',
            ),
            const SizedBox(height: 32),
            const SettingsList(),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF333333), // Dark grey background
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white24,
            backgroundImage: const AssetImage(Assets.pngWelcomeImage),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => RouteManager.goTo(RouteManager.editProfile),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFDFF587), // Light green
                shape: BoxShape.circle,
              ),
              child: const Icon(
                IconsaxPlusLinear.edit,
                size: 20,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsList extends ConsumerWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final pageController = ref.watch(layoutProvider.notifier);
    return Column(
      children: [
        SettingsItem(
          icon: IconsaxPlusLinear.colorfilter,
          label: 'My Crops',
          onTap: () => pageController.state = HomePages.cropCycle,
        ),
        SettingsItem(
          icon: IconsaxPlusLinear.add,
          label: 'Add New Device',
          onTap: () {
            RouteManager.goTo(RouteManager.devicesList);
          },
        ),
        SettingsItem(
          icon: IconsaxPlusLinear.notification,
          label: 'Notifications',
          onTap: () {
            RouteManager.goTo(RouteManager.alerts);
          },
        ),
        SettingsItem(
          icon: IconsaxPlusLinear.note,
          label: 'Consult History',
          onTap: () => pageController.state = HomePages.scan,
        ),
        SettingsItem(
          icon: IconsaxPlusLinear.messages_2,
          label: 'Chat With Expert',
          onTap: () {
            '01211501846'.openWhatsApp();
          },
        ),
        SettingsItem(
          icon: IconsaxPlusLinear.logout,
          label: 'Logout',
          onTap: () {
            ref.read(authProvider.notifier).logout(true);
            RouteManager.replaceUntilOrAll(RouteManager.welcome);
          },
        ),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: ColorsManager.textBlack, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.textBlack,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF333333),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
