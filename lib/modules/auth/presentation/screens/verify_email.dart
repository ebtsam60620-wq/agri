import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_header_text.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:agri/core/resources/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/loading_indicator.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/textstyles.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailScreen extends HookConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otp = useTextEditingController();
    final authState = ref.watch(authProvider);

    return AuthScaffold(
      onNext: () {},
      body: ListView(
        children: [
          const AuthHeaderText(
            title: 'Verify your email',
            subtitle: 'Enter the code we sent you on your email',
          ),
          const SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 5,
              controller: otp,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // onSubmitted: widget.onSubmitted,
              // onCompleted: widget.onSubmitted,
              preFilledWidget: Text(
                '•',
                style: TextStylesManager.black.black24wBold.copyWith(
                  color: ColorsManager.textGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 0.4,
                ),
              ),
              defaultPinTheme: PinTheme(
                width: 62,
                height: 51,
                padding: const EdgeInsets.all(11),
                textStyle: TextStylesManager.black.black24wBold.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 0.5,
                ),
                decoration: BoxDecoration(
                  color: ColorsManager.textFieldBg,
                  border: Border.all(color: ColorsManager.borderGrey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (authState.loadingState == Requestenum.loading)
            const LoadingIndicator()
          else
            MyButton(
              childWidget: const Text('Next', style: TextStylesManager.button),
              onPressed: () {
                //  RouteManager.goTo(RouteManager.createNewPassword);
                // authNotifier.login(email: email.text, password: password.text);
              },
            ),
        ],
      ),
    );
  }
}
