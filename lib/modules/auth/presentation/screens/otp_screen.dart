import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/assets.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/generated/app_localizations.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_success_dialog.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/loading_indicator.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:agri/presentation/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

enum OtpMethod { phone, email }

// 1. Clean Arguments Class
class OtpScreenArgs {
  final OtpMode mode;
  final OtpMethod method;

  const OtpScreenArgs({
    this.mode = OtpMode.verfy,
    this.method = OtpMethod.email,
  });
}

enum OtpMode { verfy, passwordReset }

// 2. Converted to ConsumerStatefulWidget
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  late TextEditingController _otpController;
  bool _isVerify = true;

  OtpMethod method = OtpMethod.email;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();

    // 3. Extract args and set state after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  void _initializeScreen() {
    final args = context.getRouteSettings().arguments;
    final authState = ref.read(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // Safely parse arguments
    if (args is OtpScreenArgs) {
      _isVerify = args.mode == OtpMode.verfy;
      method = args.method;
    } else if (args is OtpMode) {
      _isVerify = args == OtpMode.verfy;
      method = authState.otpMethod; // Fallback to current state
    }

    // Set the OTP method globally in your AuthNotifier state
    // authNotifier.setOtpMethod();

    // Initial code request
    if (_isVerify) {
      authNotifier.sendCode(method);
    } else if (authState.otpPhoneNumber != null &&
        (!(authState.currentScreenFlow ==
                AuthCurrentScreenFlow.forgotPassword &&
            (authState.loadingState == Requestenum.success ||
                authState.loadingState == Requestenum.loading)))) {
      authNotifier.forgotPassword(method: method);
    }
    Future.microtask(() => setState(() {}));
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onBtnPressed() {
    if (_otpController.text.length == 4) {
      final authNotifier = ref.read(authProvider.notifier);
      authNotifier.verifyPhone(_otpController.text);
      // _isVerify
      //     ? authNotifier.verifyPhone(_otpController.text)
      //     : authNotifier.otpPasswordReset(_otpController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final l10n = AppLocalizations.of(context);

    // Navigation and UI side-effects
    ref.listen(authProvider, (_, current) {
      if (current.loadingState == Requestenum.success) {
        switch (current.currentScreenFlow) {
          case AuthCurrentScreenFlow.enteringOTP:
            _otpController.text = current.otp?.code ?? '';
            if (_otpController.text.isNotEmpty) {
              // Auto-verify if the code was retrieved successfully
              authNotifier.verifyPhone(_otpController.text);
            }
          case AuthCurrentScreenFlow.verifyPhone:
            AuthSuccessDialog.show(context);
            RouteManager.firstScreen(user: current.user, goto: false);
          case AuthCurrentScreenFlow.checkotp:
            RouteManager.goTo(RouteManager.createNewPassword);
          default:
            break;
        }
      }
      if (current.loadingState == Requestenum.error &&
          current.errorMessage != null &&
          (current.currentScreenFlow == AuthCurrentScreenFlow.enteringOTP ||
              current.currentScreenFlow == AuthCurrentScreenFlow.verifyPhone ||
              current.currentScreenFlow == AuthCurrentScreenFlow.checkotp)) {
        mySnackBar(current.errorMessage!, context);
      }
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 28,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.textWhite,
        border: Border.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    // 4. Dynamic UI Labels based on the current OtpMethod
    final String targetLabel = authState.otpMethod == OtpMethod.email
        ? "Email" // Replace with l10n.email if you have it in AppLocalizations
        : "otpPhoneNumber";

    final String targetValue = _isVerify
        ? (authState.otpMethod == OtpMethod.email
              ? authState.user?.email ?? '...'
              : authState.user?.phone ?? '...')
        : (authState.otpPhoneNumber ?? '...');

    return AuthScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
           "otpVerification",
            style: TextStylesManager.black.black12w400.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
         
          const SizedBox(height: 24),
          Text(
            "otpCodeSentTo $targetLabel",
            style: TextStylesManager.white.white16w400.copyWith(
              color: ColorsManager.textWhite.withAlpha(0.85.toAlpha),
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            targetValue,
            style: TextStylesManager.black.black14w500.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Pinput(
            length:4,
            controller: _otpController,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: Colors.black87, width: 2),
              ),
            ),
            onCompleted: (_) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 32),
          authState.loadingState == Requestenum.loading
              ? const Center(child: LoadingIndicator())
              : MyButton(
                  color: Colors.black,
                  height: 56,
                  onPressed: _onBtnPressed,
                  childWidget: Text(
                    "Submit",
                    style: const TextStyle(
                      color: ColorsManager.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
               "otpDidntReceiveOtp",
                style: TextStyle(
                  color: ColorsManager.textBlack.withAlpha(0.9.toAlpha),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              authState.loadingState == Requestenum.loading
                  ? const Center(child: LoadingIndicator())
                  : GestureDetector(
                      onTap: () => _isVerify
                          ? authNotifier.sendCode(method)
                          : authNotifier.forgotPassword(method: method),
                      child: Text(
                       "Resend",
                        style: const TextStyle(
                          color: ColorsManager.textBlack,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
