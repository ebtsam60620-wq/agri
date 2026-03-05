import 'package:flutter/material.dart';

class AppSizeConfig {

  factory AppSizeConfig() {
    _instance ??= AppSizeConfig._();
    return _instance!;
  }
  AppSizeConfig._();

  void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    isTablet = size.shortestSide >= 600;
    topViewPadding = MediaQuery.viewPaddingOf(context).top;
  }

  static AppSizeConfig? _instance;
  late bool isTablet;
  late double height;
  late double width;
  late double topViewPadding;
}
