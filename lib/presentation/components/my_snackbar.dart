import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:agri/core/utils/extension_methods.dart';

void mySnackBar(String message, BuildContext ctx, {bool isError = true}) {
  ScaffoldMessenger.of(ctx).clearSnackBars();
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(12),
      elevation: 0,
      backgroundColor: isError ? ColorsManager.red : ColorsManager.primary,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isError
              ? ColorsManager.red.withAlpha(0.4.toAlpha)
              : ColorsManager.primary.withAlpha(0.4.toAlpha),
        ),
      ),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
