import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/components/empty_data_text.dart';
import 'package:agri/presentation/textstyles.dart';

class ErrorTextWithRetry extends StatelessWidget {
  const ErrorTextWithRetry({
    required this.text,
    required this.onRetry,
    super.key,
  });
  final String text;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyDataText(text),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onRetry,
          child: Text(
            'Retry',
            style: TextStylesManager.button.copyWith(
              color: ColorsManager.primary,
            ),
          ),
        ),
      ],
    );
  }
}
