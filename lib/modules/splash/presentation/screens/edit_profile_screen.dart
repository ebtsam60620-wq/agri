import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/custom_back_btn.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_textfield.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(splashProvider).user;
    final splashState = ref.watch(splashProvider);
    
    final nameController = useTextEditingController(text: user?.fullName ?? '');
    final phoneController = useTextEditingController(text: user?.phone ?? '');
    
    final hasChanges = useState(false);

    void checkChanges() {
      final changed = nameController.text != (user?.fullName ?? '') ||
                      phoneController.text != (user?.phone ?? '');
      if (hasChanges.value != changed) {
        hasChanges.value = changed;
      }
    }

    useEffect(() {
      nameController.addListener(checkChanges);
      phoneController.addListener(checkChanges);
      return () {
        nameController.removeListener(checkChanges);
        phoneController.removeListener(checkChanges);
      };
    }, [user]);

    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const SizedBox(width: 50, height: 50, child: CustomBackBtn()),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.textBlack,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              MyTextField(
                titleText: 'Full Name',
                controller: nameController,
                hintText: 'Enter your full name',
              ),
              const SizedBox(height: 20),
              MyTextField(
                titleText: 'Phone Number',
                controller: phoneController,
                hintText: 'Enter your phone number',
                inputType: TextInputType.phone,
              ),
              const Spacer(),
              MyButton(
                expandWidth: true,
                onPressed: hasChanges.value && splashState.loadingState != Requestenum.loading
                    ? () async {
                        await ref.read(splashProvider.notifier).updateProfile(
                          fullName: nameController.text,
                          phone: phoneController.text,
                        );
                        if (context.mounted) {
                          if (ref.read(splashProvider).loadingState == Requestenum.success) {
                            mySnackBar('Profile updated successfully!', context, isError: false);
                            RouteManager.pop();
                          } else if (ref.read(splashProvider).loadingState == Requestenum.error) {
                            mySnackBar(ref.read(splashProvider).errorMessage ?? 'Update failed', context, isError: true);
                          }
                        }
                      }
                    : null,
                childWidget: splashState.loadingState == Requestenum.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
