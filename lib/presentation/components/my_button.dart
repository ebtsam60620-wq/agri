import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';

enum MyButtonStyle {
  solid(ColorsManager.secondary, ColorsManager.white),
  liner(ColorsManager.white, ColorsManager.secondary);

  const MyButtonStyle(this.bg, this.border);
  final Color border;
  final Color bg;
}

class MyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget childWidget;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double? borderWidth;
  final double? fontSize;
  final double? radius;
  final IconData? icon;
  final MyButtonStyle? style;
  final bool expandWidth;
  final List<Color>? gradientColors;
  final List<BoxShadow>? boxShadow;
  const MyButton({
    required this.childWidget,
    this.color = ColorsManager.primary,
    this.onPressed,
    this.margin,
    this.width,
    this.padding,
    this.height,
    this.fontSize,
    this.radius,
    this.icon,
    this.borderColor,
    this.expandWidth = false,
    this.gradientColors = const [Color(0xFF00C6FB), Color(0xFF005BEA)],
    super.key,
    this.borderWidth,
    this.boxShadow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final Color? color = style?.bg ?? this.color;
    final Color? borderColor = style?.border ?? this.borderColor;
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Durations.medium4,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        margin: margin,
        height: height ?? 48,
        width: expandWidth ? double.infinity : width,
        decoration: BoxDecoration(
          color: onPressed == null ? ColorsManager.borderGrey : color,
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 1,
          ),
          // gradient: gradientColors != null
          //     ? LinearGradient(
          //         begin: Alignment(1.2, 0.3), // approximated from x1/y1
          //         end: Alignment(-1.0, -1.5), // approximated from x2/y2
          //         colors: gradientColors!,
          //       )
          //     : null,
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(radius == null ? 500 : radius!),
        ),
        child: Center(child: childWidget),
      ),
    );
  }
}
