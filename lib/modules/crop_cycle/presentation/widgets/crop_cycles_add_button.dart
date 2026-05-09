import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';
import '../screens/add_crop_cycle_screen.dart';

class CropCyclesAddButton extends StatelessWidget {
  const CropCyclesAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddCropCycleScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 20),
              SizedBox(width: 8),
              Text(
                'Add Crop Cycle',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
