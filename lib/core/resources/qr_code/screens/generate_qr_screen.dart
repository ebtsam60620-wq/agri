import 'package:agri/presentation/app_size_config.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRScreen extends StatelessWidget {
  static const String id = '/GenerateQRScreen';

  const GenerateQRScreen({super.key, this.data = 'data'});
  final String data;

  static Future show({
    required BuildContext context,
    required String redirectURL,
  }) =>
      showDialog<String?>(
        context: context,
        builder: (context) => Align(
          alignment: Alignment.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GenerateQRScreen(
                data: redirectURL,
              ),
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      size: AppSizeConfig().width - 50,
      data: data,
      version: QrVersions.auto,
    );
  }
}
