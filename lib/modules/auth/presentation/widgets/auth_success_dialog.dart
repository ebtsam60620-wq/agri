import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agri/core/resources/assets.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/textstyles.dart';

class AuthSuccessDialog extends StatelessWidget {
  const AuthSuccessDialog({super.key});
  static void show(BuildContext context) => showDialog(
    context: context,
    builder: (context) => const AuthSuccessDialog(),
  );
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255.0 * 0.08).round()),
              offset: const Offset(4, 4),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              SvgPicture.asset(Assets.svgLogoWhiteS),
              Text.rich(
                style: TextStylesManager.black.black24w600,
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(text: 'authThanksForSigningUp'),
                    TextSpan(
                      text: 'appName',
                      style: TextStylesManager.blue.blue24w600.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(text: 'authTeam'),
                  ],
                ),
              ),
              Text.rich(
                textAlign: TextAlign.start,
                TextSpan(
                  children: [
                    TextSpan(text: 'authParagraph1'),
                    TextSpan(text: 'authParagraph2'),
                    TextSpan(text: ' authParagraph3'),
                    const TextSpan(text: '\n'),
                    TextSpan(text: ' authClosing'),
                    const TextSpan(text: ',\n'),
                    TextSpan(text: 'appName'),
                    TextSpan(text: 'authTeam'),
                  ],
                ),
              ),
              MyButton(
                childWidget: Text(
                  'Go Back',
                  style: TextStylesManager.white.white16w600,
                ),
                radius: 8,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
