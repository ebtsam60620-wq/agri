import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';

class MyCheckboxWithValueNotifier extends StatelessWidget {
  final String? title;
  final Function()? changingValueFunction;
  final double titleSize;
  final double verticalPadding;
  final double horizontalPadding;
  final ValueNotifier<bool> boolValue;
  const MyCheckboxWithValueNotifier({
    super.key,
    this.title,
    required this.boolValue,
    this.changingValueFunction,
    this.titleSize = 12,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: boolValue,
      builder: (context, value, child) {
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
              boolValue.value = !boolValue.value;
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(2),
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: boolValue.value
                        ? ColorsManager.primary
                        : ColorsManager.textWhite,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: boolValue.value
                          ? ColorsManager.primary
                          : ColorsManager.textMainGrey,
                    ),
                  ),
                  child: Center(
                    child: boolValue.value
                        ? const Icon(
                            Icons.check,
                            color: ColorsManager.textWhite,
                            size: 14,
                          )
                        : null,
                  ),
                ),
                if (title != null) const SizedBox(width: 8),
                if (title != null)
                  Flexible(
                    child: Text(
                      title!,
                      style: TextStyle(
                        color: ColorsManager.textMainGrey,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
