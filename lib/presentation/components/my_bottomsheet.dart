import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';

void myBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    isScrollControlled: true,
    builder: (context) => BottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      onClosing: () {},
      // constraints: BoxConstraints(
      //     maxHeight: MediaQuery.sizeOf(context).height * 0.3,
      //     minWidth: MediaQuery.sizeOf(context).width),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: ColorsManager.textWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 4,
                    width: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: ColorsManager.iconsGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
