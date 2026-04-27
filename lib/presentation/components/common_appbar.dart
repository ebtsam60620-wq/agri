import 'dart:io';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:flutter/material.dart';
import 'package:agri/presentation/textstyles.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppbar({
    required this.title,
    this.heroTag,
    this.boldFont = true,
    this.appBarShadow = true,
    this.actions,
    super.key,
  });

  final String title;
  final Object? heroTag;
  final bool boldFont;
  final List<Widget>? actions;
  final bool appBarShadow;

  @override
  Widget build(BuildContext context) {
    final canPop = RouteManager.canPop(context: context);
    final appBarWidget = Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AppBar(
        elevation: 0,
        toolbarHeight: 62,
        automaticallyImplyLeading: false,
        backgroundColor: ColorsManager.scaffoldBgColor,
        shadowColor: appBarShadow
            ? ColorsManager.scaffoldBgColor
            : Colors.transparent,
        surfaceTintColor: ColorsManager.scaffoldBgColor,
        actions: actions,
        leading: canPop
            ? IconButton(
                onPressed: () => RouteManager.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorsManager.primary,
                ),
              )
            : null,
        titleSpacing: NavigationToolbar.kMiddleSpacing + 8,
        title: Text(
          title,
          maxLines: 2,
          style: TextStylesManager.redk16w500,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    if (heroTag != null) {
      return Hero(tag: heroTag!, child: appBarWidget);
    }
    return appBarWidget;
  }

  @override
  Size get preferredSize => Size.fromHeight(
    Platform.isIOS ? 60 : AppSizeConfig().topViewPadding + 62,
  );
}
