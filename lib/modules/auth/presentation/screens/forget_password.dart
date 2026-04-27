import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/auth/presentation/screens/otp_screen.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  const ForgetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();

    ref.listen(authProvider, (old, current) {
      if (current.currentScreenFlow == AuthCurrentScreenFlow.enteringOTP) {
        if (current.loadingState == Requestenum.success) {
          RouteManager.goTo(RouteManager.otp);
        } else if (current.loadingState == Requestenum.error) {
          mySnackBar(current.errorMessage!, context);
        }
      }
    });

    return AuthScaffold(
      onNext: () =>
          RouteManager.goTo(RouteManager.otp, arguments: OtpFlow.reset),
      uiNext: 'Send Code',
      title: 'Forget password',
      subTitle:
          'Please enter your registered email and we will\nsend you a code to reset your password',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            MyTextField(
              fillColor: ColorsManager.textFieldBg,
              controller: email,
              hintText: '01xx xxx xxxx',
              titleText: 'Email',
              // lableStyle: TextStylesManager.black.lightblack16w600,
              textInputAction: TextInputAction.next,
              inputType: TextInputType.emailAddress,
              prefixWidget: const Icon(
                IconsaxPlusBold.sms,
                color: ColorsManager.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
