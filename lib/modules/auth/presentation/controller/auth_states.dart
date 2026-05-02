part of 'auth_notifier.dart';

//   login register forget password otp
//
///
class AuthState {
  final Requestenum loadingState;
  final AuthCurrentScreenFlow currentScreenFlow;
  final String? errorMessage;
  final bool isGuest;
  final String? otpPhoneNumber;
  final User? user;
  final TokenModel? otp;
  final OtpMethod otpMethod; // Add this

  
  const AuthState({
    required this.loadingState,
    required this.currentScreenFlow,
    this.isGuest = false,
    this.otpPhoneNumber, // Default value
    this.errorMessage,
    this.user,
    this.otp,
    this.otpMethod = OtpMethod.email,
  });

  factory AuthState.initial() {
    return const AuthState(
      currentScreenFlow: AuthCurrentScreenFlow.login,
      loadingState: Requestenum.init,
    );
  }

  AuthState copyWith({
    Requestenum? loadingState,
    AuthCurrentScreenFlow? currentScreenFlow,
    bool? isGuest,
    String? errorMessage,
    String? otpPhoneNumber,
    String? otpCode,
    User? user,
    TokenModel? otp,
    OtpMethod? otpMethod, // Add this
  }) {
    return AuthState(
      loadingState: loadingState ?? this.loadingState,
      currentScreenFlow: currentScreenFlow ?? this.currentScreenFlow,
      isGuest: isGuest ?? this.isGuest,
      otpPhoneNumber: otpPhoneNumber ?? this.otpPhoneNumber,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      otp: otp ?? this.otp,
      otpMethod: otpMethod ?? this.otpMethod,
    );
  }

  @override
  String toString() {
    return 'AuthState('
        'loadingState: $loadingState, '
        'currentScreenFlow: $currentScreenFlow, '
        'isGuest: $isGuest, '
        'otpPhoneNumber: $otpPhoneNumber, '
        'errorMessage: $errorMessage, '
        'user: ${user?.userID ?? 'null'}'
        'nextOtpAt ${otp?.time.toSmartString() ?? 'null '}'
        ')';
  }
}

enum AuthCurrentScreenFlow {
  register,
  login,

  enteringOTP,
  verifyPhone,

  forgotPassword,
  checkotp,
  resetPassword,

  logout,
}
