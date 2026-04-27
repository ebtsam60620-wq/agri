import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class NewPasswordScreen extends HookConsumerWidget {
  const NewPasswordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    // final authState = ref.watch(authProvider);
    // final authNotifier = ref.read(authProvider.notifier);
    ref.listen(authProvider, (old, current) {
      if (current.currentScreenFlow == AuthCurrentScreenFlow.login) {
        if (current.loadingState == Requestenum.success) {
          //  RouteManager.gotoUntilOrAll(RouteManager.home);
        } else if (current.loadingState == Requestenum.error) {
          mySnackBar(current.errorMessage!, context);
        }
      }
    });
    return AuthScaffold(
      onNext: () {},
      uiNext: 'Reset Password',
      title: 'Reset password',
      body: ListView(
        children: [
          MyTextField(
            fillColor: ColorsManager.textFieldBg,
            controller: email,
            hintText: '********',
            titleText: ' Password',
            textInputAction: TextInputAction.next,

            prefixWidget: const Icon(
              IconsaxPlusBold.key,
              color: ColorsManager.primary,
              size: 24,
            ),
            isPassword: true,
          ),
          SizedBox(height: 10),
          MyTextField(
            fillColor: ColorsManager.textFieldBg,
            controller: password,
            hintText: '********',
            titleText: ' Confirm Password',
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
