import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';
import 'package:agri/modules/auth/domain/repository/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
part 'auth_states.dart';

class AuthNotifier extends Notifier<AuthState> {
  AuthNotifier(
    this._authRepo,
  );

  @override
  AuthState build() {
    final user = _authRepo.localDataSource.returnUser();
    return AuthState.initial().copyWith(user: user);
  }

  final AuthRepo _authRepo;
  void setUserType(UserTypeEnum userType) {
    state = state.copyWith(userType: userType);
  }

  void setphoneNumber(String phoneNumber) =>
      state = state.copyWith(otpPhoneNumber: phoneNumber);

  Future<void> signup({
    required RegisterFormDto registerFormDto,
    required AuthCurrentScreenFlow currentScreenFlow,
  }) async {
    state = state.copyWith(
      loadingState: AuthLoadingState.loading,
      currentScreenFlow: currentScreenFlow,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.signup(
      registerFormDto: registerFormDto,
    );
    result.fold(
      (left) {
        state = state.copyWith(
            loadingState: AuthLoadingState.error, errorMessage: left.message);
      },
      (right) {
        state = state.copyWith(
          user: right,
          loadingState: AuthLoadingState.success,
        );
      },
    );
  }


  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      currentScreenFlow: AuthCurrentScreenFlow.login,
      loadingState: AuthLoadingState.loading,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.login(
      email: email,
      password: password,
      userType: state.userType,
    );
    result.fold((failure) async {
      state = state.copyWith(
        loadingState: AuthLoadingState.error,
        errorMessage: failure.message,
      );
    }, (data) async {
      state = state.copyWith(
        user: data,
        loadingState: AuthLoadingState.success,
      );
    });
  }

  // Future<void> providerDataDetails({
  //   required ProviderDataFormModel userDataForm,
  // }) async {
  //   state = state.copyWith(loadingState: AuthLoadingState.loading);
  //   final result = await _authRepo.providerDataFormModel(
  //     userDataForm: userDataForm,
  //   );
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.success,
  //     );
  //   });
  // }


  Future<void> getTerms() async {
    state = state.copyWith(
      loadingState: AuthLoadingState.loading,
      currentScreenFlow: AuthCurrentScreenFlow.getTerms,
    );
    final result = await _authRepo.getTerms();
    result.fold((failure) {
      state = state.copyWith(
        loadingState: AuthLoadingState.error,
        errorMessage: failure.message,
      );
    }, (data) {
      state = state.copyWith(
        loadingState: AuthLoadingState.success,
      );
    });
  }

  Future<void> getDisclaimer() async {
    state = state.copyWith(
      loadingState: AuthLoadingState.loading,
      currentScreenFlow: AuthCurrentScreenFlow.getTerms,
    );
    final result = await _authRepo.getDisclaimer();
    result.fold((failure) {
      state = state.copyWith(
        loadingState: AuthLoadingState.error,
        errorMessage: failure.message,
      );
    }, (data) {
      state = state.copyWith(
        loadingState: AuthLoadingState.success,
      );
    });
  }
  // Future<void> googleLogin({
  //   required bool isSignUp,
  //   required bool rememberMe,
  // }) async {
  //   state = state.copyWith(loadingState: AuthLoadingState.loadingSocialAuth);
  //   final result =
  //       await _authRepo.googleLogin(isSignUp: isSignUp, rememberMe: rememberMe);
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       currentScreenFlow: isSignUp
  //           ? AuthCurrentScreenFlow.register
  //           : AuthCurrentScreenFlow.login,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.success,
  //       currentScreenFlow: isSignUp
  //           ? AuthCurrentScreenFlow.register
  //           : AuthCurrentScreenFlow.login,
  //       redirectDesicion: data.redirectDesicion,
  //       authToken: data.authToken,
  //     );
  //   });
  // }

  // Future<void> facebookLogin({
  //   required bool isSignUp,
  //   required bool rememberMe,
  // }) async {
  //   state = state.copyWith(loadingState: AuthLoadingState.loadingSocialAuth);
  //   final result = await _authRepo.facebookLogin(
  //       isSignUp: isSignUp, rememberMe: rememberMe);
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       currentScreenFlow: isSignUp
  //           ? AuthCurrentScreenFlow.register
  //           : AuthCurrentScreenFlow.login,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.success,
  //       currentScreenFlow: isSignUp
  //           ? AuthCurrentScreenFlow.register
  //           : AuthCurrentScreenFlow.login,
  //       redirectDesicion: data.redirectDesicion,
  //       authToken: data.authToken,
  //     );
  //   });
  // }

  // Future<void> guestLogin() async {
  //   state = state.copyWith(
  //       currentScreenFlow: AuthCurrentScreenFlow.login,
  //       loadingState: AuthLoadingState.loading);
  //   final result = await _authRepo.guestLogin();
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       authToken: data,
  //       isGuest: true,
  //       loadingState: AuthLoadingState.successGuestLogin,
  //     );
  //   });
  // }

  Future<void> sendCode(String type, String number) async {
    state = state.copyWith(
      loadingState: AuthLoadingState.loading,
      currentScreenFlow: AuthCurrentScreenFlow.enteringOTP,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.sendCode(type, number);
    result.fold((failure) {
      state = state.copyWith(
        loadingState: AuthLoadingState.error,
        errorMessage: failure.message,
      );
    }, (data) {
      state = state.copyWith(
        loadingState: AuthLoadingState.sendOtpSuccess,
        otpRequestedAt: data,
      );
    });
  }

  Future<void> forgotPassword(String type, String number) async {
    state = state.copyWith(
      loadingState: AuthLoadingState.loading,
      currentScreenFlow: AuthCurrentScreenFlow.forgotPassword,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.forgotPassword(type, number);
    result.fold((failure) {
      state = state.copyWith(
        loadingState: AuthLoadingState.error,
        errorMessage: failure.message,
      );
    }, (ResponseAdapter data) {
      state = state.copyWith(
        loadingState: AuthLoadingState.success,
        successMessage: data.data['data']['message'],
        resetToken: data.data['debugData']?['resetToken'] as String?,
      );
    });
  }

  Future<void> verifyPhone(String otp) async {
    state = state.copyWith(
      currentScreenFlow: AuthCurrentScreenFlow.enteringOTP,
      loadingState: AuthLoadingState.loading,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.verifyPhone(otp);
    result.fold((failure) {
      state = state.copyWith(
        loadingState: AuthLoadingState.error,
        errorMessage: failure.message,
      );
    }, (data) {
      state = state.copyWith(
        loadingState: AuthLoadingState.success,
      );
    });
  }

  // Future<void> resendCode() async {
  //   final result = await _authRepo.resendCode();
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       authToken: data,
  //       loadingState: AuthLoadingState.otpRequestedAgain,
  //     );
  //   });
  // }

  // Future<void> verifyEmail(String otp) async {
  //   state = state.copyWith(
  //       currentScreenFlow: AuthCurrentScreenFlow.enteringOTP,
  //       loadingState: AuthLoadingState.loading);

  //   final result = await _authRepo.verifyEmail(otp);
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       authToken: data.authToken,
  //       loadingState: AuthLoadingState.success,
  //     );
  //   });
  // }

  // Future<void> otp2FA(String otp) async {
  //   state = state.copyWith(
  //       currentScreenFlow: AuthCurrentScreenFlow.enteringOTP,
  //       loadingState: AuthLoadingState.loading);

  //   final result = await _authRepo.otp2FA(otp);
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       authToken: data.authToken,
  //       loadingState: AuthLoadingState.success,
  //     );
  //   });
  // }

  // Future<void> forgotPassword(String email) async {
  //   state = state.copyWith(
  //       currentScreenFlow: AuthCurrentScreenFlow.forgotPassword,
  //       loadingState: AuthLoadingState.loading);
  //   final result = await _authRepo.forgotPassword(email);
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       authToken: data,
  //       loadingState: AuthLoadingState.success,
  //     );
  //   });
  // }

  // Future<void> otpPasswordReset(String otp) async {
  //   state = state.copyWith(
  //       currentScreenFlow: AuthCurrentScreenFlow.enteringOTP,
  //       loadingState: AuthLoadingState.loading);
  //   final result = await _authRepo.otpPasswordReset(otp);
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       authToken: data,
  //       loadingState: AuthLoadingState.success,
  //     );
  //   });
  // }

  Future<void> passwordReset(String token, String newPassword) async {
    state = state.copyWith(
        currentScreenFlow: AuthCurrentScreenFlow.resetPassword,
        loadingState: AuthLoadingState.loading,
        errorMessage: null,
        successMessage: null);
    final result = await _authRepo.passwordReset(token, newPassword);
    result.fold((failure) {
      state = state.copyWith(
        loadingState: AuthLoadingState.error,
        errorMessage: failure.message,
      );
    }, (data) {
      state = state.copyWith(
        // authToken: data,
        loadingState: AuthLoadingState.success,
        successMessage: data.data['data']['message'] as String? ?? 'Success',
      );
    });
  }

  Future<void> logout(bool doLogoutRequest) async {
    _authRepo.logout(doLogoutRequest);
    state = AuthState.initial().copyWith(
      currentScreenFlow: AuthCurrentScreenFlow.logout,
      loadingState: AuthLoadingState.success,
    );
  }

  // Future<void> deleteAccount() async {
  //   state = state.copyWith(loadingState: AuthLoadingState.loading);
  //   final result = await _authRepo.deleteAccount();
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       loadingState: AuthLoadingState.success,
  //     );
  //     logout(false);
  //   });
  // }
}
