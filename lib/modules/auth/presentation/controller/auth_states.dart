part of 'auth_notifier.dart';

class AuthState {
  final Requestenum loadingState;
  final AuthCurrentScreenFlow currentScreenFlow;
  final String? errorMessage;
  final String? successMessage;
  final String? resetToken;
  final bool isGuest;
  final UserTypeEnum userType;
  final String otpPhoneNumber;
  final DateTime? otpRequestedAt;
  final User? user;

  const AuthState({
    required this.loadingState,
    required this.currentScreenFlow,
    this.user,
    this.userType = UserTypeEnum.patient,
    this.successMessage,
    this.isGuest = false,
    this.errorMessage,
    this.otpPhoneNumber = '',
    this.otpRequestedAt,
    this.resetToken,
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
    User? user,
    bool? isGuest,
    String? errorMessage,
    UserTypeEnum? userType,
    String otpPhoneNumber = '',
    DateTime? otpRequestedAt,
    String? successMessage,
    String? resetToken,
  }) {
    return AuthState(
      loadingState: loadingState ?? this.loadingState,
      currentScreenFlow: currentScreenFlow ?? this.currentScreenFlow,
      user: user ?? this.user,
      isGuest: isGuest ?? this.isGuest,
      userType: userType ?? this.userType,
      errorMessage: errorMessage,
      otpPhoneNumber:
          otpPhoneNumber.isNotEmpty ? otpPhoneNumber : this.otpPhoneNumber,
      otpRequestedAt: otpRequestedAt ?? this.otpRequestedAt,
      successMessage: successMessage ?? this.successMessage,
      resetToken: resetToken ?? this.resetToken,
    );
  }

  @override
  String toString() {
    return 'AuthState('
        'loadingState: $loadingState, '
        'currentScreenFlow: $currentScreenFlow, '
        'userType: $userType, '
        'isGuest: $isGuest, '
        'errorMessage: $errorMessage'
        ', otpPhoneNumber: $otpPhoneNumber'
        ', otpRequestedAt: $otpRequestedAt'
        ', successMessage: $successMessage'
        ', resetToken: $resetToken'
        ')';
  }
}



enum AuthCurrentScreenFlow {
  selectType,
  login,
  register,
  selectProviderCategories,
  sendotp,
  verifyphoneNumber,
  forgotPassword,
  enteringOTP,
  logout,
  resetPassword,
}