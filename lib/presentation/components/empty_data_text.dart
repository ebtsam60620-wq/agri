import 'package:flutter/material.dart';
import 'package:agri/presentation/textstyles.dart';

class EmptyDataText extends StatelessWidget {
  const EmptyDataText(this.text, {this.onRefresh, super.key});
  final String text;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final textWidget = Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStylesManager.black.black24wBold,
      ),
    );
    if (onRefresh == null) {
      return textWidget;
    } else {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            children: [
              SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: textWidget,
              ),
            ],
          ),
        ),
      );
    }
  }
}
