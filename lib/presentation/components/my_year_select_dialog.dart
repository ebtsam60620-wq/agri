import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class MyYearSelectDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const MyYearSelectDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  /// Static method to show the dialog and return the selected DateTime
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (context) => MyYearSelectDialog(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
      ),
    );
  }

  @override
  State<MyYearSelectDialog> createState() => _MyYearSelectDialogState();
}

class _MyYearSelectDialogState extends State<MyYearSelectDialog> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(IconsaxPlusBold.calendar, size: 24),
          SizedBox(width: 10),
          Text('Select Year'),
        ],
      ),
      content: SizedBox(
        // Set a fixed height and width for the year picker
        width: 300,
        height: 300,
        child: YearPicker(
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectedDate: _selectedDate,
          onChanged: (DateTime dateTime) {
            setState(() {
              _selectedDate = dateTime;
            });
            // Automatically close and return value on selection
            Navigator.pop(context, dateTime);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
