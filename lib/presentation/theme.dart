import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';

ThemeData arabicThemeData = ThemeData(
  buttonTheme: const ButtonThemeData(
    alignedDropdown: true,
  ),
  scaffoldBackgroundColor: ColorsManager.scaffoldBgColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorsManager.primary,
    primary: ColorsManager.primary,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    height: 84,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: ColorsManager.primary,
  ),
  fontFamily: 'inter',
);

ThemeData englishThemeData = ThemeData(
  buttonTheme: const ButtonThemeData(
    alignedDropdown: true,
  ),
  scaffoldBackgroundColor: ColorsManager.scaffoldBgColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorsManager.primary,
    primary: ColorsManager.primary,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    height: 84,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: ColorsManager.primary,
  ),
  fontFamily: 'inter',
);
