import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyTextField extends StatefulWidget {
  final String? titleText;
  final String? labelText;
  final String? hintText;
  final String? initialText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final bool isPassword;
  final Function(String value)? onChanged;
  final void Function(String)? onSubmit;
  final Function()? onTap;
  final bool isEnabled;
  final bool readOnly;
  final int? maxLines;
  final InputDecoration? decoration;
  final String? prefixIconPath;
  final String? suffixSvgIconPath;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final int? maxLength;
  final bool showMaxLength;
  final double? height;
  final double? constraintsMaxHeight;
  final double? constraintsMaxWidth;
  final double? radius;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;
  final Color? fillColor;
  final TextAlign align;
  final bool? expands;
  final String? Function(String? value)? validation;
  final bool hideOnTapOutside;
  final TextInputAction? textInputAction;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? lableStyle;
  final TextStyle? valueStyle;
  final bool borderlessFoucsed;
  final String? errorText;
  final double borderWidth;

  const MyTextField({
    super.key,
    this.titleText,
    this.labelText,
    this.hintText,
    this.initialText,
    this.decoration,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.readOnly = false,
    this.inputType = TextInputType.text,
    this.expands,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.onSubmit,
    this.validation,
    this.prefixIconPath,
    this.suffixSvgIconPath,
    this.prefixWidget,
    this.suffixWidget,
    this.isPassword = false,
    this.maxLength,
    this.showMaxLength = false,
    this.radius,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.fillColor,
    this.align = TextAlign.start,
    this.height,
    this.constraintsMaxHeight,
    this.hideOnTapOutside = false,
    this.textInputAction,
    this.constraintsMaxWidth,
    this.textAlignVertical,
    this.contentPadding,
    this.hintStyle,
    this.lableStyle,
    this.valueStyle,
    this.errorText,
    this.borderWidth = 2,
    this.borderlessFoucsed = false,
  });

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  late final FocusNode focusNode;
  late Color prefixColor;

  @override
  void initState() {
    prefixColor = ColorsManager.borderGrey;
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          prefixColor = ColorsManager.primary;
        } else {
          prefixColor = ColorsManager.borderGrey;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theTextField = SizedBox(
      height: widget.height,
      child: TextFormField(
        textInputAction: widget.textInputAction,
        initialValue: widget.initialText,
        onTapOutside: (event) => widget.hideOnTapOutside
            ? FocusManager.instance.primaryFocus?.unfocus()
            : null,
        readOnly: widget.readOnly,
        maxLength: widget.showMaxLength ? widget.maxLength : null,
        onTap: widget.onTap,
        inputFormatters: [
          if (widget.maxLength != null)
            LengthLimitingTextInputFormatter(widget.maxLength),
        ],
        onFieldSubmitted: widget.onSubmit,
        textAlign: widget.align,
        textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
        expands: (widget.expands == true && widget.maxLines == null),
        maxLines: widget.maxLines,
        minLines: widget.maxLines != null ? 1 : null,
        controller: widget.controller,
        focusNode: focusNode,
        obscuringCharacter: '●',
        style: widget.valueStyle ?? TextStylesManager.textField,
        keyboardType: widget.inputType,
        cursorColor: ColorsManager.textBlack,
        enabled: widget.isEnabled,
        autofocus: false,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration:
            widget.decoration ??
            InputDecoration(
              errorText: widget.errorText,
              contentPadding:
                  widget.contentPadding ??
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelText: widget.labelText,
              labelStyle: TextStylesManager.textField.copyWith(
                color: ColorsManager.iconsGrey,
              ),
              hintText: widget.hintText,
              hintStyle:
                  widget.hintStyle ??
                  TextStylesManager.textField.copyWith(
                    color: ColorsManager.iconsGrey,
                  ),
              errorStyle: TextStylesManager.textField.copyWith(
                color: ColorsManager.red,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 13),
                borderSide: BorderSide(
                  color: ColorsManager.red,
                  width: widget.borderWidth,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 13),
                borderSide: BorderSide(
                  color: ColorsManager.red,
                  width: widget.borderWidth,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 13),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? ColorsManager.borderGrey,
                  width: widget.borderWidth,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 13),
                borderSide: widget.borderlessFoucsed
                    ? BorderSide.none
                    : BorderSide(
                        color:
                            widget.enabledBorderColor ??
                            ColorsManager.borderGrey,
                        width: widget.borderWidth,
                      ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 13),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? ColorsManager.primary,
                  width: widget.borderWidth,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 13),
                borderSide: BorderSide(
                  color: widget.disabledBorderColor ?? ColorsManager.borderGrey,
                  width: widget.borderWidth,
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: widget.constraintsMaxHeight ?? 44,
                maxWidth: widget.constraintsMaxWidth ?? 44,
              ),
              suffixIcon: widget.suffixWidget != null
                  ? Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        0,
                        12,
                        12,
                        12,
                      ),
                      child: widget.suffixWidget,
                    )
                  : (widget.isPassword
                        ? Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              0,
                              12,
                              12,
                              12,
                            ),
                            child: GestureDetector(
                              onTap: _toggle,
                              child: AnimatedCrossFade(
                                duration: Durations.medium4,
                                reverseDuration: Durations.medium4,
                                crossFadeState: _obscureText
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                firstChild: const Icon(
                                  Icons.visibility_off_rounded,
                                  color: ColorsManager.borderGrey,
                                ),
                                secondChild: const Icon(
                                  Icons.visibility_rounded,
                                  color: ColorsManager.borderGrey,
                                ),
                              ),
                            ),
                          )
                        : Column(
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
                                    (widget.suffixSvgIconPath != null &&
                                        widget.suffixSvgIconPath!.contains(
                                          '.svg',
                                        ))
                                    ? SvgPicture.asset(
                                        widget.suffixSvgIconPath!,
                                      )
                                    : widget.suffixSvgIconPath == null
                                    ? null
                                    : Image.asset(widget.suffixSvgIconPath!),
                              ),
                            ],
                          )),
              isDense: true,
              filled: true,
              fillColor: widget.fillColor ?? ColorsManager.textWhite,
              //               prefixIconConstraints: const BoxConstraints(
              //   maxHeight: 44,
              //   maxWidth: 44,
              // ),
              prefixIcon:
                  widget.prefixWidget == null && widget.prefixIconPath == null
                  ? null
                  : Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        12,
                        0,
                        8,
                        0,
                      ),
                      child:
                          widget.prefixWidget ??
                          ((widget.prefixIconPath != null &&
                                  widget.prefixIconPath!.contains('.svg'))
                              ? SvgPicture.asset(widget.prefixIconPath!)
                              : widget.prefixIconPath == null
                              ? null
                              : Image.asset(widget.prefixIconPath!)),
                    ),
            ),
        onChanged: widget.onChanged,
        validator: widget.validation,
      ),
    );
    return widget.titleText == null
        ? theTextField
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                widget.titleText!,
                style:
                    widget.lableStyle ??
                    TextStyle(
                      color: focusNode.hasFocus
                          ? ColorsManager.primary
                          : ColorsManager.textBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              theTextField,
            ],
          );
  }
}
