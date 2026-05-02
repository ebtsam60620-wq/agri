import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:agri/presentation/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final splashrepo = ref.watch(splashProvider);
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
                onPressed: () {},
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
          Container(
            width: AppSizeConfig().width,
            decoration: BoxDecoration(
              color: ColorsManager.black,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(15),
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
                      padding: EdgeInsets.symmetric(
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
                              color: ColorsManager.lightGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: ColorsManager.lightGreen,
                              fontSize: 16,
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
                          Text(
                            'Module Location',
                            style: TextStyle(
                              color: ColorsManager.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '41.40338, 2.17403',
                            style: TextStyle(
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
                          Text(
                            'Module ID',
                            style: TextStyle(
                              color: ColorsManager.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'AGRI-IOT-001',
                            style: TextStyle(
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
                          Text(
                            'Last Update',
                            style: TextStyle(
                              color: ColorsManager.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '09:00 AM',
                            style: TextStyle(
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
                          Text(
                            'Update Interval',
                            style: TextStyle(
                              color: ColorsManager.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Every hour',
                            style: TextStyle(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
