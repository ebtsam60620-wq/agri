// import 'package:flutter/material.dart';
// import 'package:agri/core/configs/colors_manager.dart';
// import 'package:agri/core/resources/assets.dart';
// import 'package:agri/core/utils/user_type_enum.dart';
// import 'package:agri/data/models/provider_category_model.dart';
// import 'package:agri/generated/app_localizations.dart';

// class UserTypeModel {
//   final String title;
//   final Color color;
//   final String imagePath;
//   final UserTypeEnum userType;
//   final bool isRight;
//   final ValueNotifier<UserTypeModel?> isSelected;
//   late final ProviderCategoryModel? _doctorType;

//   ProviderCategoryModel? get doctorType => _doctorType;

//   set doctorType(ProviderCategoryModel? value) {
//     if (userType == UserTypeEnum.provider) {
//       _doctorType = value;
//     } else {
//       _doctorType = null;
//     }
//   }

//   UserTypeModel({
//     required this.title,
//     required this.color,
//     required this.imagePath,
//     required this.userType,
//     required this.isSelected,
//     this.isRight = true,
//     ProviderCategoryModel? doctorType,
//   }) {
//     if (userType == UserTypeEnum.provider) {
//       this.doctorType = doctorType;
//     } else {
//       this.doctorType = null;
//     }
//     // log(_doctorType.toString());
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is UserTypeModel &&
//         other.userType == userType &&
//         other._doctorType == _doctorType;
//   }

//   @override
//   int get hashCode => userType.hashCode ^ _doctorType.hashCode;

//   static medicalTypes(
//           BuildContext context, ValueNotifier<UserTypeModel?> notifier) =>
//       [
//         UserTypeModel(
//           title: AppLocalizations.of(context).doctors,
//           color: ColorsManager.primary,
//           imagePath: Assets.doctor,
//           userType: UserTypeEnum.provider,
//           isSelected: notifier,
//         ),
//         UserTypeModel(
//           title: AppLocalizations.of(context).nurses,
//           color: ColorsManager.primary,
//           imagePath: Assets.nurse,
//           userType: UserTypeEnum.provider,
//           isSelected: notifier,
//           isRight: false,
//         ),
//         UserTypeModel(
//           title: AppLocalizations.of(context).lab_specialist,
//           color: ColorsManager.redFF6565,
//           imagePath: Assets.labSpecialist,
//           userType: UserTypeEnum.provider,
//           isSelected: notifier,
//         ),
//         UserTypeModel(
//           title: AppLocalizations.of(context).radiology_specialist,
//           color: ColorsManager.blue000B41,
//           imagePath: Assets.radiology,
//           userType: UserTypeEnum.provider,
//           isSelected: notifier,
//           isRight: false,
//         ),
//       ];

//   static userTypeList(
//           BuildContext context, ValueNotifier<UserTypeModel?> notifier) =>
//       [
//         UserTypeModel(
//           title: AppLocalizations.of(context).health_guest,
//           color: ColorsManager.redFF6565,
//           imagePath: Assets.family,
//           userType: UserTypeEnum.patient,
//           isSelected: notifier,
//           isRight: false,
//         ),
//         UserTypeModel(
//           title: AppLocalizations.of(context).health_host,
//           color: ColorsManager.primary,
//           imagePath: Assets.doctor,
//           userType: UserTypeEnum.provider,
//           isSelected: notifier,
//         ),
//       ];
// }
// //
