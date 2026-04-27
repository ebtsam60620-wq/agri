import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_header_text.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/loading_indicator.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:agri/presentation/textstyles.dart';

class AuthChangePasswordScreen extends HookConsumerWidget {
  const AuthChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final authState = ref.watch(authProvider);
    //final authNotifier = ref.read(authProvider.notifier);

    // ref.listen(authProvider, (old, current) {
    //   if (current.currentScreenFlow == AuthCurrentScreenFlow.login) {
    //     if (current.loadingState == Requestenum.success) {
    //       context.replaceRoute(const HomeRoute());
    //     } else if (current.loadingState == Requestenum.error) {
    //       mySnackBar(current.errorMessage!, context);
    //     }
    //   }
    // });

    return AuthScaffold(
      onNext: () {},

      body: ListView(
        children: [
          const AuthHeaderText(
            title: 'Change Password',
            subtitle: 'Enter your new password',
          ),
          const SizedBox(height: 16),
          MyTextField(
            controller: password,
            hintText: 'New Password',
            prefixWidget: const Icon(Icons.lock, color: Colors.grey),
            isPassword: true,
          ),
          const SizedBox(height: 16),
          MyTextField(
            controller: confirmPassword,
            hintText: 'Confirm Password',
            prefixWidget: const Icon(Icons.lock, color: Colors.grey),
            isPassword: true,
          ),
          const SizedBox(height: 16),
          if (authState.loadingState == Requestenum.loading)
            const LoadingIndicator()
          else
            MyButton(
              childWidget: const Text('Next', style: TextStylesManager.button),
              onPressed: () {
                RouteManager.replaceUntilOrAll(RouteManager.login);
                // authNotifier.login(email: email.text, password: password.text);
              },
            ),
        ],
      ),
    );
  }
}
