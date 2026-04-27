import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/components/my_button.dart';

class NavigationRow extends StatelessWidget {
  const NavigationRow({
    super.key,
    this.prevTitle,
    this.nextTitle,
    this.prevIcon,
    this.nextIcon,
    this.optionsIcon = Icons.more_horiz, // Added default icon for options
    this.spacing = 16,
    this.onPrev,
    this.onNext,
    this.onOptions,
    this.prevTextStyle,
    this.prevColor = ColorsManager.textWhite,
    this.prevTextColor = ColorsManager.grey,
  });

  final String? prevTitle;
  final String? nextTitle;
  final IconData? prevIcon;
  final IconData? nextIcon;
  final IconData? optionsIcon;
  final double spacing;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onOptions;

  final TextStyle? prevTextStyle;
  final Color prevColor;
  final Color prevTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing,
      children: [
        // --- PREVIOUS BUTTON ---
        if (onPrev != null)
          Expanded(
            flex: 1,
            child: MyButton(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              height: 50,
              gradientColors: null,
              color: prevColor,
              childWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prevIcon != null) Icon(prevIcon, color: prevTextColor),
                  if (prevTitle != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      prevTitle!,
                      style:
                          prevTextStyle ??
                          const TextStyle(
                            color: ColorsManager.grey,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ],
              ),
              onPressed: onPrev,
            ),
          ),

        // --- NEXT/MAIN BUTTON ---
        if (onNext != null)
          Expanded(
            flex: 3,
            child: MyButton(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: 50,
              childWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (nextTitle != null)
                    Text(
                      nextTitle!,
                    ),
                  if (nextIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(nextIcon, color: ColorsManager.textWhite),
                  ],
                ],
              ),
              onPressed: onNext,
            ),
          ),

        // --- OPTIONS BUTTON ---
        if (onOptions != null)
          Expanded(
            flex: 1,
            child: MyButton(
              padding: EdgeInsets.zero,
              height: 50,
              gradientColors: null,
              color: prevColor, // Matches the theme of the back button
              childWidget: Icon(optionsIcon, color: prevTextColor),
              onPressed: onOptions,
            ), // Keeps layout consistent but hides if null
          ),
      ],
    );
  }
}
