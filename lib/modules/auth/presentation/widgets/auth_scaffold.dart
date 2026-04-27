import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/app_size_config.dart';
import 'package:agri/presentation/textstyles.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorsManager.scaffoldBgColor,
      appBar: AuthAppBar(title: title ?? '', step: step, subTitle: subTitle),
      body: Container(
        margin: EdgeInsets.only(top: 60, right: 20, left: 20),
        child: body,
      ),
      bottomNavigationBar: AuthBottomNav(
        onNext: onNext,
        uiNext: uiNext,
        subTitle: bottomSubTitle,
        subEnd: bottomSubEnd,
        onSub: onSub,
        onSelectChange: onSelectChange,
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
  });
  final String? uiNext, subTitle, subEnd;
  final void Function()? onNext, onSub;
  final ValueChanged<bool?>? onSelectChange;
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
                        changingValueFunction: () {
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
                  onTap: onSub,
                  child: Text(
                    subEnd!,
                    style: TextStylesManager.black.black14w700,
                  ),
                ),
              ],
            ),
          if (onNext != null)
            MyButton(
              margin: EdgeInsets.symmetric(horizontal: 20),
              onPressed: onNext,
              childWidget: Text(
                uiNext!,
                style: TextStyle(color: ColorsManager.white),
              ),
              color: ColorsManager.secondary,
            ),
          SizedBox(
            height: 15 + MediaQuery.of(context).viewPadding.bottom,
          ), // 15 + Button Navigation if open + maby keybaord ?
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
