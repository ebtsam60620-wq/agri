import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';

class MyCheckbox extends StatelessWidget {
  final String? title;
  final Function()? changingValueFunction;
  final double titleSize;
  final double verticalPadding;
  final double horizontalPadding;
  final bool value;
  final TextStyle? style;
  final Widget? suffixWidget;
  final bool isCircle;

  const MyCheckbox({
    super.key,
    this.title,
    required this.value,
    this.changingValueFunction,
    this.titleSize = 16,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.style,
    this.suffixWidget,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        0,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      ),
      child: InkWell(
        onTap: () {
          if (changingValueFunction != null) {
            changingValueFunction!();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isCircle)
              Container(
                margin: const EdgeInsets.all(2),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: value
                      ? ColorsManager.primary
                      : ColorsManager.textWhite,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: value
                        ? ColorsManager.primary
                        : ColorsManager.grey,
                  ),
                ),
                child: Center(
                  child: value
                      ? const Icon(
                          Icons.check,
                          color: ColorsManager.textWhite,
                          size: 14,
                        )
                      : null,
                ),
              ),
            if (isCircle)
              Container(
                margin: const EdgeInsets.all(2),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: value
                      ? ColorsManager.primary
                      : ColorsManager.textWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value
                        ? ColorsManager.primary
                        : ColorsManager.grey,
                  ),
                ),
                child: Center(
                  child: value
                      ? Container(
                          height: 6,
                          width: 6,
                          decoration: const BoxDecoration(
                            color: ColorsManager.textWhite,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              ),
            if (title != null) const SizedBox(width: 8),
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: TextStyle(
                    color: ColorsManager.black414651,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: suffixWidget ?? const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
