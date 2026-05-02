import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/auth/presentation/screens/otp_screen.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_success_dialog.dart';
import 'package:agri/presentation/components/error_container_state.dart';
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

    // 1. Create a Form key using hooks to maintain its state across rebuilds
    final formKey = useMemoized(() => GlobalKey<FormState>());

    ref.listen(authProvider, (old, current) {
      if (current.currentScreenFlow == AuthCurrentScreenFlow.login) {
        if (current.loadingState == Requestenum.success) {
          RouteManager.firstScreen(user: current.user);
        } else if (current.loadingState == Requestenum.error) {
          mySnackBar(current.errorMessage!, context);
        }
      }
    });

    final notifier = ref.read(authProvider.notifier);
    final state = ref.watch(authProvider);

    return AuthScaffold(
      title: 'Login Account',
      subTitle: 'Welcome Back!',
      bottomSubTitle: 'Donot Have an account?',
      bottomSubEnd: 'Create Account',
      onSub: () => RouteManager.goTo(RouteManager.signUpUser),
      uiNext: 'Continue',
      isLoading:
          state.currentScreenFlow == AuthCurrentScreenFlow.login &&
          state.loadingState == Requestenum.loading,

      // 2. Update onNext to trigger validation before calling the API
      onNext: () {
        if (formKey.currentState?.validate() ?? false) {
          notifier.login(email: email.text.trim(), password: password.text);
        }
      },

      // 3. Wrap your Column in a Form widget
      body: Form(
        key: formKey,
        child: Column(
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
              // 4. Add the Email validator
              validation: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                // Basic email regex
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                    color: ColorsManager.textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => RouteManager.goTo(RouteManager.forgotPassword),
                  child: const Text('Forget Password?'),
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
              // 5. Add the Password validator
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  // Optional: enforce minimum length
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            if (state.currentScreenFlow == AuthCurrentScreenFlow.login &&
                state.loadingState == Requestenum.error &&
                state.errorMessage != null)
              ErrorContainerState(errorMessage: state.errorMessage!),
          ],
        ),
      ),
    );
  }
}
