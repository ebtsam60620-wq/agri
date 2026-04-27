import 'package:flutter/material.dart';

class MyDateSelectDialog extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const MyDateSelectDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  /// Static method to trigger the Date Picker and return the selected date
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    // We use the built-in showDatePicker but wrap it in a custom theme
    // to match your Iconsax aesthetic.
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: const DatePickerThemeData(
              headerHeadlineStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This widget is primarily used via the static .show() method
    return const SizedBox.shrink();
  }
}
