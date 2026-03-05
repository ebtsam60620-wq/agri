import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/presentation/textstyles.dart';

class MyDropDownTextField<T> extends StatelessWidget {
  const MyDropDownTextField({
    super.key,
    required this.dataList,
    this.value,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.prefixSvgIconPath,
    this.suffixSvgIconPath,
    this.height,
    this.width,
    this.radius,
    this.onChanged,
    this.color,
    this.activeBorderColor = ColorsManager.primary,
    this.selectedItemStyle,
    this.borderColor,
    this.borderlessFoucsed = true,
    this.prefixWidget,
  });
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? selectedItemStyle;
  final String? hintText;
  final Map<T, dynamic> dataList;
  final T? value;
  final String? prefixSvgIconPath;
  final String? suffixSvgIconPath;
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  final Color? activeBorderColor;
  final Color? borderColor;
  final bool borderlessFoucsed;
  final Widget? prefixWidget;
  final void Function(T? newValue)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(
            labelText!,
            style:
                labelStyle ??
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        if (labelText != null) const SizedBox(height: 8),
        SizedBox(
          height: height ?? 51,
          width: width ?? double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<T?>(
              initialValue: value,
              selectedItemBuilder: (context) => dataList.entries
                  .map<Widget>(
                    (mapEntry) => Text(
                      mapEntry.value.toString(),
                      style: selectedItemStyle ?? TextStylesManager.textField,
                    ),
                  )
                  .toList(),
              icon: suffixSvgIconPath != null
                  ? const SizedBox.shrink()
                  : const Icon(
                      IconsaxPlusBold.arrow_down,
                      color: ColorsManager.primary,
                      size: 25,
                    ),
              hint: hintText != null
                  ? Text(hintText!, style: TextStylesManager.grey.grey15W400)
                  : null,
              style: TextStylesManager.textField,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(7),
                labelStyle: TextStylesManager.textField,
                hintText: hintText,
                hintStyle: TextStylesManager.textField,
                errorStyle: TextStylesManager.textField.copyWith(
                  color: ColorsManager.red,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 13),
                  borderSide: BorderSide(
                    color: ColorsManager.red.withAlpha(0.2.toAlpha),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 13),
                  borderSide: BorderSide(
                    color: ColorsManager.red.withAlpha(0.2.toAlpha),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 13),
                  borderSide: borderlessFoucsed
                      ? const BorderSide(width: 0)
                      : BorderSide(
                          color: borderColor ?? color ?? Colors.transparent,
                        ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 13),
                  borderSide: borderlessFoucsed
                      ? BorderSide.none
                      : BorderSide(color: borderColor ?? Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 13),
                  borderSide: BorderSide(
                    color: activeBorderColor ?? ColorsManager.borderGrey,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 13),
                  borderSide: const BorderSide(color: ColorsManager.borderGrey),
                ),
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 44,
                  maxWidth: 44,
                ),
                suffixIcon: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        0,
                        12,
                        12,
                        12,
                      ),
                      child:
                          (suffixSvgIconPath != null &&
                              suffixSvgIconPath!.contains('.svg'))
                          ? SvgPicture.asset(suffixSvgIconPath!)
                          : suffixSvgIconPath == null
                          ? null
                          : Image.asset(suffixSvgIconPath!),
                    ),
                  ],
                ),
                isDense: true,
                fillColor: color ?? Colors.white,
                filled: true,
                prefixIcon: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        12,
                        12,
                        0,
                        12,
                      ),
                      child:
                          prefixWidget ??
                          ((prefixSvgIconPath != null &&
                                  prefixSvgIconPath!.contains('.svg'))
                              ? SvgPicture.asset(
                                  prefixSvgIconPath!,
                                  height: 16,
                                  width: 24,
                                )
                              : prefixSvgIconPath == null
                              ? null
                              : Image.asset(
                                  prefixSvgIconPath!,
                                  height: 16,
                                  width: 24,
                                )),
                    ),
                  ],
                ),
                prefixIconConstraints: const BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 50,
                ),
              ),
              items: dataList.isEmpty
                  ? null
                  : dataList.entries
                        .map<DropdownMenuItem<T>>(
                          (mapEntry) => DropdownMenuItem<T>(
                            value: mapEntry.key,
                            child: Text(mapEntry.value.toString()),
                          ),
                        )
                        .toList(),
              onChanged: dataList.isNotEmpty ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
