import 'package:agri/presentation/components/loading_indicator.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:agri/presentation/textstyles.dart';
// Note: Make sure to import your LoadingIndicator widget here if it's in a separate file!
// import 'package:agri/presentation/components/loading_indicator.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.body,
    super.key,
    // AppBar Props
    this.title,
    this.subTitle,
    this.step,
    // BottomNav Props
    this.uiNext = 'next',
    this.bottomSubTitle,
    this.bottomSubEnd,
    this.onNext,
    this.onSub,
    this.onSelectChange,
    this.isLoading = false, // <-- Added isLoading prop
    // Container Props
    this.height,
    this.width,
  });

  final Widget body;
  final double? height, width;

  // AppBar Fields
  final String? title;
  final String? subTitle;
  final int? step;

  // BottomNav Fields
  final String? uiNext;
  final String? bottomSubTitle;
  final String? bottomSubEnd;
  final void Function()? onNext;
  final void Function()? onSub;
  final ValueChanged<bool?>? onSelectChange;
  final bool isLoading; // <-- Added isLoading variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorsManager.scaffoldBgColor,
      appBar: AuthAppBar(title: title ?? '', step: step, subTitle: subTitle),
      body: Container(
        margin: const EdgeInsets.only(top: 60, right: 20, left: 20),
        child: body,
      ),
      bottomNavigationBar: AuthBottomNav(
        onNext: onNext,
        uiNext: uiNext,
        subTitle: bottomSubTitle,
        subEnd: bottomSubEnd,
        onSub: onSub,
        onSelectChange: onSelectChange,
        isLoading: isLoading, // <-- Passed isLoading to BottomNav
      ),
    );
  }
}

class AuthBottomNav extends StatelessWidget {
  const AuthBottomNav({
    super.key,
    this.uiNext = 'next',
    this.subTitle,
    this.subEnd,
    this.onNext,
    this.onSub,
    this.onSelectChange,
    this.isLoading = false, // <-- Added isLoading prop
  });

  final String? uiNext, subTitle, subEnd;
  final void Function()? onNext, onSub;
  final ValueChanged<bool?>? onSelectChange;
  final bool isLoading; // <-- Added isLoading variable

  @override
  Widget build(BuildContext context) {
    bool value = false;
    return SizedBox(
      width: AppSizeConfig().width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          if (subTitle != null && subEnd != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 3,
              children: [
                if (onSelectChange != null)
                  StatefulBuilder(
                    builder: (context, fun) {
                      return MyCheckbox(
                        isCircle: false,
                        value: value,
                        changingValueFunction: isLoading
                            ? null
                            : () {
                                // <-- Disabled checkbox while loading
                                fun(() {
                                  value = !value;
                                  onSelectChange?.call(value);
                                });
                              },
                      );
                    },
                  ),
                Text(subTitle!, style: TextStylesManager.black.black12w500),
                GestureDetector(
                  onTap: isLoading
                      ? null
                      : onSub, // <-- Disabled tap while loading
                  child: Text(
                    subEnd!,
                    style: TextStylesManager.black.black14w700,
                  ),
                ),
              ],
            ),
          if (onNext != null)
            MyButton(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: isLoading
                  ? null
                  : onNext, // <-- Disabled button while loading
              color: ColorsManager.secondary,
              // <-- Replaced Text with LoadingIndicator when isLoading is true
              childWidget: isLoading
                  ? const LoadingIndicator()
                  : Text(uiNext!, style: TextStyle(color: ColorsManager.white)),
            ),
          SizedBox(height: 15 + MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key, required this.title, this.subTitle, this.step});

  final String title;
  final String? subTitle;
  final int? step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: AppSizeConfig().topViewPadding,
        start: 16,
        end: 16,
      ),
      child: SizedBox(
        width: AppSizeConfig().width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (step != null)
              SizedBox(
                height: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: List.generate(
                    2,
                    (i) => Container(
                      width: 56,
                      decoration: BoxDecoration(
                        color: i == (step! - 1)
                            ? ColorsManager.secondary
                            : ColorsManager.lightGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
            Text(title, style: TextStylesManager.black.black24wBold),
            if (subTitle != null)
              Text(subTitle!, style: TextStylesManager.black.black14w500),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    AppSizeConfig().topViewPadding + 40 + (step == null ? 0 : 40),
  );
}
