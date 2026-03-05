import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({
    super.key,
    this.width,
    this.height,
    this.alignment = AlignmentDirectional.bottomEnd,
    this.onTap,
    required this.child,
    this.boxDecoration,
    this.addIcon,
    this.showImage = true,
    this.source = ImageSource.gallery,
    this.pickMultiImages = false,
    this.changeChild = true,
    this.onMultiImages,
  });

  final double? width, height;
  final BoxDecoration? boxDecoration;
  final Widget child;
  final Widget? addIcon;
  final void Function(XFile)? onTap;
  final void Function(List<XFile>)? onMultiImages;
  final AlignmentGeometry alignment;
  final bool showImage, pickMultiImages;
  final ImageSource source;
  final bool changeChild;
  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File? imagePath;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: widget.boxDecoration,
                clipBehavior:
                    widget.boxDecoration != null ? Clip.hardEdge : Clip.none,
                child: (imagePath != null && widget.changeChild)
                    ? widget.showImage
                        ? Image.file(
                            imagePath!,
                            fit: BoxFit.cover,
                          )
                        : widget.child
                    : widget.child,
              ),
            ),
            if (widget.addIcon != null)
              Align(
                alignment: widget.alignment,
                child: widget.addIcon,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> onTap() async {
    final ImagePicker picker = ImagePicker();
    if (widget.pickMultiImages) {
      final List<XFile> response = await picker.pickMultiImage();
      if (response.isEmpty) {
        return;
      }
      widget.onMultiImages?.call(response);
    } else {
      final XFile? response = await picker.pickImage(source: widget.source);
      if (response == null) {
        return;
      }
      imagePath = File(response.path);
      setState(() {});
      widget.onTap?.call(response);
    }
  }
}
