import 'package:agri/core/resources/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRDialog extends StatefulWidget {
  const ScanQRDialog({super.key});
  static Future<String?> show(BuildContext context) async {
    return showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ScanQRDialog(),
    );
  }

  @override
  State<ScanQRDialog> createState() => _ScanQRDialogState();
}

class _ScanQRDialogState extends State<ScanQRDialog> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool hasPermission = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        hasPermission = true;
        isProcessing = false;
      });
    } else {
      setState(() => isProcessing = false);
      var status = await Permission.camera.request();
      if (status.isGranted) {
        if (mounted) {
          setState(() {
            hasPermission = true;
          });
        }
      } else if (status.isPermanentlyDenied) {
        if (mounted) {
          await openAppSettings();
          // Check permission again after returning from settings
          await _requestCameraPermission();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required to scan QR codes.'),
            ),
          );
          RouteManager.pop(); // Close QR dialog
        }
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.first.then((scanData) {
      if (scanData.code != null && mounted) {
        controller.dispose();
        RouteManager.pop(result: scanData.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final appLoc = AppLocalizations.of(context);
    return AlertDialog(
      title: Text("appLoc.scanQr"),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          child: hasPermission
              ? QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Theme.of(context).primaryColor,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 250,
                  ),
                )
              : const Center(
                  child: Text('Waiting for camera permission...'),
                )),
      actions: [
        TextButton(
          onPressed: () => RouteManager.pop(),
          child: Text("appLoc.cancel"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
