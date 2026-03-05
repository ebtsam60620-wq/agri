part of 'auth_notifier.dart';

class AuthState {
  final AuthLoadingState loadingState;
  final AuthCurrentScreenFlow currentScreenFlow;
  final String? errorMessage;
  final String? successMessage;
  final String? resetToken;
  final bool isGuest;
  final UserTypeEnum userType;
  final String otpPhoneNumber;
  final DateTime? otpRequestedAt;
  final ProviderCategoryModel? providerType;
  final List<ProviderCategoryModel> providerCategories;
  final String? terms, disclaimer;
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
    this.providerType,
    this.providerCategories = const [],
    this.resetToken,
    this.terms,
    this.disclaimer,
  });

  factory AuthState.initial() {
    return const AuthState(
      currentScreenFlow: AuthCurrentScreenFlow.login,
      loadingState: AuthLoadingState.initial,
    );
  }

  AuthState copyWith({
    AuthLoadingState? loadingState,
    AuthCurrentScreenFlow? currentScreenFlow,
    User? user,
    bool? isGuest,
    String? errorMessage,
    UserTypeEnum? userType,
    String otpPhoneNumber = '',
    DateTime? otpRequestedAt,
    String? successMessage,
    ProviderCategoryModel? providerType,
    String? resetToken,
    List<ProviderCategoryModel>? providerCategories,
    String? disclaimer,
    String? terms,
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
      providerType: providerType ?? this.providerType,
      resetToken: resetToken ?? this.resetToken,
      providerCategories: providerCategories ?? this.providerCategories,
      disclaimer: disclaimer ?? this.disclaimer,
      terms: terms ?? this.terms,
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
        ', providerType: $providerType'
        ', resetToken: $resetToken'
        ', providerCategories: $providerCategories)';
  }
}

enum AuthLoadingState {
  initial,
  loading,
  // loadingSocialAuth,
  error,
  // otpRequestedAgain,
  // successGuestLogin,
  success,
  sendOtpSuccess,
  getProviderCategories,
}

enum AuthCurrentScreenFlow {
  selectType,
  login,
  registerPatient,
  registerProvider,
  selectProviderCategories,
  sendotp,
  verifyphoneNumber,
  forgotPassword,
  enteringOTP,
  // signupProviderData,
  logout,
  resetPassword,
  getTerms,
  getdiscalamir,
}
