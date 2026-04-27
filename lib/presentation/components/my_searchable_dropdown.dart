import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/components/empty_data_text.dart';
import 'package:agri/presentation/textstyles.dart';

class MySearchableDropDown<T> extends StatelessWidget {
  const MySearchableDropDown({
    super.key,
    // required this.value,
    required this.itemAsString,
    this.labelText,
    this.hintText,
    this.prefixSvgIconPath,
    this.height,
    this.width,
    this.radius,
    required this.items,
    this.labelStyle,
    this.validator,
    this.itemAsImage,
    this.searchDelay,
    required this.onSelect,
    this.autoValidateMode = AutovalidateMode.disabled,
  });
  // final ValueNotifier<T> value;
  final String? labelText;
  final String? hintText;
  final String? prefixSvgIconPath;
  final String Function()? itemAsImage;
  final double? height;
  final double? width;
  final double? radius;
  final String Function(T val) itemAsString;
  final List<T> items;
  final TextStyle? labelStyle;
  final String? Function(T?)? validator;
  final AutovalidateMode? autoValidateMode;
  final Duration? searchDelay;
  final void Function(T) onSelect;
  @override
  Widget build(BuildContext context) {
    StateSetter? rebuildImage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null)
          Text(
            labelText!,
            style:
                labelStyle ??
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        if (labelText != null) const SizedBox(height: 10),
        SizedBox(
          height: height ?? 51,
          width: width ?? double.infinity,
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              // if (textEditingValue.text.isEmpty) {
              //   return const Iterable<String>.empty();
              // }
              return items
                  .map((e) => itemAsString(e).toLowerCase())
                  .where(
                    (element) =>
                        element.contains(textEditingValue.text.toLowerCase()),
                  )
                  .toList();
            },
            // displayStringForOption: itemAsString,
            onSelected: (String val) {
              onSelect(
                items.firstWhere(
                  (element) =>
                      itemAsString(element).toLowerCase() == val.toLowerCase(),
                ),
              );
              rebuildImage?.call(() {});
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      hintText: hintText,
                      hintStyle: TextStylesManager.textField.copyWith(
                        color: ColorsManager.iconsGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radius ?? 16),
                        borderSide: const BorderSide(
                          color: ColorsManager.borderGrey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radius ?? 16),
                        borderSide: const BorderSide(
                          color: ColorsManager.borderGrey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radius ?? 16),
                        borderSide: const BorderSide(
                          color: ColorsManager.borderGrey,
                        ),
                      ),
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: prefixSvgIconPath == null
                          ? null
                          : Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                12,
                                12,
                                8,
                                12,
                              ),
                              child: itemAsImage == null
                                  ? (prefixSvgIconPath!.contains('.svg'))
                                        ? SvgPicture.asset(prefixSvgIconPath!)
                                        : Image.asset(prefixSvgIconPath!)
                                  : StatefulBuilder(
                                      builder: (context, fun) {
                                        rebuildImage = fun;
                                        return CachedNetworkImage(
                                          imageUrl: itemAsImage!(),
                                        );
                                      },
                                    ),
                            ),
                      suffixIcon: const Icon(
                        IconsaxPlusBold.arrow_down,
                        color: ColorsManager.textGrey,
                        size: 24,
                      ),
                    ),
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: options.isEmpty
                        ? const EmptyDataText('No results found')
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                title: Text(option),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
