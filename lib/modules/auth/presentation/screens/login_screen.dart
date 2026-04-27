import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/auth/presentation/screens/otp_screen.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();

    ref.listen(authProvider, (old, current) {
      if (current.currentScreenFlow == AuthCurrentScreenFlow.login) {
        if (current.loadingState == Requestenum.success) {
          //  RouteManager.gotoUntilOrAll(RouteManager.home);
          AuthSuccessDialog.show(context);
        } else if (current.loadingState == Requestenum.error) {
          mySnackBar(current.errorMessage!, context);
        }
      }
    });

    return AuthScaffold(
      title: 'Login Account',
      subTitle: 'Welcome Back!',
      bottomSubTitle: 'Donot Have an account?',
      bottomSubEnd: 'Create Account',
      onSub: () => RouteManager.goTo(RouteManager.signUpUser),
      uiNext: 'Continue',
      onNext: () =>
          RouteManager.goTo(RouteManager.otp, arguments: OtpFlow.verifyPhone),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16,
        children: [
          MyTextField(
            fillColor: ColorsManager.textFieldBg,
            controller: email,
            hintText: 'Email',
            titleText: ' Email',
            textInputAction: TextInputAction.next,
            inputType: TextInputType.emailAddress,
            prefixWidget: const Icon(
              IconsaxPlusBold.profile,
              color: ColorsManager.primary,
              size: 24,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: TextStyle(
                  color: ColorsManager.textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => RouteManager.goTo(RouteManager.forgotPassword),
                child: Text('Forget Password?'),
              ),
            ],
          ),
          MyTextField(
            fillColor: ColorsManager.textFieldBg,
            controller: password,
            hintText: '********',
            textInputAction: TextInputAction.done,
            prefixWidget: const Icon(
              IconsaxPlusBold.key,
              color: ColorsManager.primary,
              size: 24,
            ),
            isPassword: true,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
