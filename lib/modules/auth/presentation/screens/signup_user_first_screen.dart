import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/error_container_state.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SignUpUserFirstScreen extends HookConsumerWidget {
  const SignUpUserFirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Setup Form Key for validation
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // 2. Setup Text Controllers
    final fullNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // 3. Local state for terms checkbox
    final acceptedTerms = useState(false);
    final state = ref.watch(authProvider); 
    return AuthScaffold(
      step: 1,
      title: 'Create an account',
      subTitle: 'To Sign In To Account In The Application',
      bottomSubTitle: 'I agree to follow the',
      bottomSubEnd: 'terms of use',
      onSub: () {
        // Handle navigation to sign in
      },
      onSelectChange: (value) {
        // Update local terms state
        acceptedTerms.value = value ?? false;
      },
      onNext: () {
        // 4. Validate and Submit
        if (formKey.currentState!.validate()) {
          if (!acceptedTerms.value) {
            mySnackBar('Please accept the terms of use', context);
            return;
          }

          ref
              .read(authProvider.notifier)
              .signup(
                registerFormDto: RegisterFormDto(
                  fullName: fullNameController.text.trim(),
                  phone: phoneController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text,
                  acceptedTerms: acceptedTerms.value,
                ),
              );
        }
      },
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            MyTextField(
              titleText: 'Full Name',
              controller: fullNameController,
              hintText: 'Enter Your Full Name',
              validation: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter your name';
                if (value.length < 2)
                  return 'Name must be at least 2 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),

            MyTextField(
              titleText: 'Phone Number',
              controller: phoneController,
              hintText: '01xx xxx xxxx',
              inputType: TextInputType.phone,
              maxLength: 14,
              prefixWidget: const Icon(
                IconsaxPlusBold.call,
                color: ColorsManager.primary,
              ),
              validation: (value) => value == null || value.isEmpty
                  ? 'Please enter your phone number'
                  : null,
            ),
            const SizedBox(height: 16),

            MyTextField(
              titleText: 'Email Address',
              controller: emailController,
              hintText: 'agri@email.com',
              inputType: TextInputType.emailAddress,
              prefixWidget: const Icon(
                IconsaxPlusBold.sms,
                color: ColorsManager.primary,
              ),
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                } else if (!RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            MyTextField(
              titleText: 'Password',
              controller: passwordController,
              hintText: '••••••••',
              inputType: TextInputType.visiblePassword,
              prefixWidget: const Icon(
                IconsaxPlusBold.key,
                color: ColorsManager.primary,
              ),
              validation: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter a password';
                if (value.length < 8)
                  return 'Password must be at least 8 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (state.loadingState == Requestenum.error &&
                state.currentScreenFlow == AuthCurrentScreenFlow.register)
              ErrorContainerState(errorMessage: state.errorMessage!),
          ],
        ),
      ),
    );
  }
}
