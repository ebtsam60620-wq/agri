import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_snackbar.dart';

class NameDeviceDialog extends ConsumerStatefulWidget {
  final String qrCode; // The code you scanned previously

  const NameDeviceDialog({super.key, required this.qrCode});

  // Helper method to easily show this dialog from anywhere
  static Future<void> show(BuildContext context, String scannedCode) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents tapping outside to dismiss
      builder: (context) => PopScope(
        canPop:
            false, // Prevents the physical Android back button from closing it
        child: NameDeviceDialog(qrCode: scannedCode),
      ),
    );
  }

  @override
  ConsumerState<NameDeviceDialog> createState() =>
      _NameDeviceDialogConsumerState();
}

class _NameDeviceDialogConsumerState extends ConsumerState<NameDeviceDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  late final controller = ref.read(device.notifier);
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitAndLink() async {
    final deviceName = _nameController.text.trim();
    if (deviceName.isEmpty) {
      mySnackBar("Please enter a device name", context);
      return;
    }

    setState(() {
      _isLoading = true; // Show loading spinner on the button
    });

    try {
      // 1. Call your Notifier Method here and wait for it to finish
      await controller.linkModule(code: widget.qrCode, nickname: deviceName);

      if (mounted) {
        final state = ref.read(device);
        if (state.status == Requestenum.success) {
          // 2. Navigate to Home Screen and clear the routing stack
          RouteManager.replaceUntilOrAll(RouteManager.home);
        } else if (state.status == Requestenum.error) {
          mySnackBar(state.errorMessage ?? "Failed to link", context);
        }
      }
    } catch (e) {
      // Handle any linking errors here
      if (mounted) {
        mySnackBar("Failed to link: $e", context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Shrinks column to fit content
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              "Name Your Device",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Give your newly scanned device a custom name to easily identify it later.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // MyTextField (Replace with your custom widget if needed)
            MyTextField(
              controller: _nameController,
              isEnabled: !_isLoading, // Disable input while linking
              titleText: "Device Name",
              hintText: "e.g., Living Room Camera",
              prefixWidget: const Icon(Icons.devices),
            ),
            const SizedBox(height: 32),

            // My Button
            MyButton(
              onPressed: _isLoading ? null : _submitAndLink,
              expandWidth: true,
              childWidget: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "LINK DEVICE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
