import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:agri/core/resources/route_manager.dart'; // Using your route manager

class ScanCodeScreen extends StatefulWidget {
  const ScanCodeScreen({super.key});

  @override
  State<ScanCodeScreen> createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends State<ScanCodeScreen> {
  // Setup the controller
  // DetectionSpeed.noDuplicates prevents the scanner from firing 100 times a second
  final MobileScannerController controller = MobileScannerController(
    formats: const [
      BarcodeFormat.qrCode,
    ], // Optimization: Only look for QR codes
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  // Flag to prevent multiple pops if the camera reads the code twice rapidly
  bool isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Back Button
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => RouteManager.pop(),
              ),
            ),

            // 2. Title & 3. Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scan Device QR",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Hold your phone over the QR code located on your device.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 4. Container with Dotted Border containing the camera
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: AspectRatio(
                    aspectRatio: 1.0, // Keeps the camera view a perfect square
                    child: CustomPaint(
                      painter: DottedBorderPainter(
                        color: ColorsManager.primary,
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Colors.black12, // Slight tint before camera loads
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: MobileScanner(
                          controller: controller,
                          onDetect: (BarcodeCapture capture) {
                            final List<Barcode> barcodes = capture.barcodes;

                            if (barcodes.isNotEmpty && !isScanned) {
                              final String? code = barcodes.first.rawValue;
                              if (code != null) {
                                // Lock scanning
                                setState(() => isScanned = true);

                                // Pause the camera immediately upon success
                                controller.stop();

                                // Return the result
                                RouteManager.pop(result: code);
                              }
                            }
                          },
                          // Optional: Gracefully handle camera permission denials
                          errorBuilder: (context, error) {
                            return Center(
                              child: Text(
                                "Camera Error: \n${error.errorDetails?.message ?? 'Permission denied'}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 5. My Button Scan (Toggle Flash)
            MyButton(
              margin: const EdgeInsets.all(32.0),

              onPressed: () =>
                  controller.toggleTorch(), // Flashlight toggle built right in
              childWidget: const Text(
                "TOGGLE FLASH",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for the Dotted Border
class DottedBorderPainter extends CustomPainter {
  final Color color;
  DottedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8.0;
    const double dashSpace = 8.0;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(25),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
