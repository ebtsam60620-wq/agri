import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:agri/presentation/textstyles.dart';

enum OtpFlow { reset, verifyPhone }

class OtpVerificationScreen extends HookConsumerWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = context.getRouteSettings();
    final otp = settings.arguments is OtpFlow
        ? settings.arguments
        : OtpFlow.verifyPhone;
    return AuthScaffold(
      onNext: () => RouteManager.goTo(
        otp == OtpFlow.verifyPhone
            ? RouteManager.home
            : RouteManager.createNewPassword,
      ),
      uiNext: 'Verify Code',
      title: 'Enter Verification Code',
      subTitle:
          'Please enter code that we have sent to your\nemail AGRI3*******@gmail.com',
      bottomSubTitle: 'I Don’t Receive Code!',
      bottomSubEnd: 'Resend',
      body: Column(
        children: [
          const SizedBox(height: 20),
          Pinput(
            length: 4,
            preFilledWidget: Text(
              '*',
              // style: TextStylesManager.grey.greyB4B4B435W400.copyWith(
              //   color: ColorsManager.primary,
              // ),
            ),
            defaultPinTheme: PinTheme(
              width: 50,
              height: 50,
              textStyle: TextStylesManager.blue.blue32w400,
              decoration: BoxDecoration(
                color: ColorsManager.grey,
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: Colors.grey),
              ),
            ),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            focusedPinTheme: PinTheme(
              width: 50,
              height: 50,
              textStyle: TextStylesManager.blue.blue32w400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorsManager.primary),
              ),
            ),
            cursor: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  color: ColorsManager.primary,
                  width: 10,
                  height: 4,
                ),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 50,
              height: 50,
              textStyle: TextStylesManager.blue.blue32w400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorsManager.primary, width: 1.5),
              ),
            ),
            onChanged: (value) {},
            onCompleted: (value) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
