import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';
import 'package:agri/modules/auth/data/models/token_model.dart';
import 'package:agri/modules/auth/domain/repository/auth_repository.dart';
import 'package:agri/modules/auth/presentation/screens/otp_screen.dart';
import 'package:agri/notifiers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
part 'auth_states.dart';

class AuthNotifier extends Notifier<AuthState> {
  AuthNotifier(this._authRepo, this._userLocalDataSource);

  @override
  AuthState build() {
    return AuthState.initial().copyWith(
      user: _userLocalDataSource.returnUser(),
    );
  }

  final UserLocalDataSource _userLocalDataSource;
  final AuthRepo _authRepo;

  // --- Helper to reduce boilerplate ---
  void _setLoading(
    AuthCurrentScreenFlow flow, {
    OtpMethod? method,
    String? number,
  }) {
    state = state.copyWith(
      loadingState: Requestenum.loading,
      otpMethod: method,
      currentScreenFlow: flow,
      errorMessage: null,
      otpPhoneNumber: number,
    );
  }

  void _setError(String message) {
    state = state.copyWith(
      loadingState: Requestenum.error,
      errorMessage: message,
    );
  }

  Future<void> signup({
    required RegisterFormDto registerFormDto,
    Function(int, int)? onSendProgress,
  }) async {
    if (state.currentScreenFlow == AuthCurrentScreenFlow.register &&
        state.loadingState == Requestenum.loading) {
      return;
    }
    try {
      _setLoading(AuthCurrentScreenFlow.register);
      final result = await _authRepo.signup(
        registerFormDto: registerFormDto,
        onSendProgress: onSendProgress,
      );
      result.fold((left) => _setError(left.message), (right) {
        ref.read(splashProvider.notifier).setUser(right);
        state = state.copyWith(user: right, loadingState: Requestenum.success);
      });
    } catch (e) {
      _setError('unexpected_signup_error // $e');
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (state.currentScreenFlow == AuthCurrentScreenFlow.login &&
        state.loadingState == Requestenum.loading) {
      return;
    }
    try {
      _setLoading(AuthCurrentScreenFlow.login);
      final result = await _authRepo.login(email: email, password: password);
      result.fold((failure) => _setError(failure.message), (data) {
        ref.read(splashProvider.notifier).setUser(data);
        state = state.copyWith(loadingState: Requestenum.success, user: data);
      });
    } catch (e) {
      _setError('unexpected_login_error');
    }
  }

  Future<void> sendCode(OtpMethod method) async {
    if (state.currentScreenFlow == AuthCurrentScreenFlow.enteringOTP &&
        state.loadingState == Requestenum.loading) {
      return;
    }
    try {
      _setLoading(AuthCurrentScreenFlow.enteringOTP);
      final result = await _authRepo.sendCode(
        state.otpMethod.name,
        state.user!.email!,
      );
      result.fold(
        (failure) => _setError(failure.message),
        (data) => state = state.copyWith(loadingState: Requestenum.success),
      );
    } catch (e) {
      _setError('failed_to_send_code');
    }
  }

  Future<void> verifyPhone(String otp) async {
    if (state.currentScreenFlow == AuthCurrentScreenFlow.verifyPhone &&
        state.loadingState == Requestenum.loading) {
      return;
    }
    try {
      _setLoading(AuthCurrentScreenFlow.verifyPhone);
      final result = await _authRepo.verifyPhone(otp, state.user!.email!);
      result.fold(
        (failure) => _setError(failure.message),
        (data) => state = state.copyWith(
          loadingState: Requestenum.success,
          user: state.user?.copyWith(isVerified: true),
        ),
      );
    } catch (e) {
      _setError('verification_failed');
    }
  }

  Future<void> forgotPassword({
    required OtpMethod method,
    String? number,
  }) async {
    try {
      if (state.currentScreenFlow == AuthCurrentScreenFlow.forgotPassword &&
          state.loadingState == Requestenum.loading) {
        return;
      }
      if (state.otpPhoneNumber == null && number == null) {
        return;
      }
      number ??= state.otpPhoneNumber;
      _setLoading(
        AuthCurrentScreenFlow.forgotPassword,
        method: method,
        number: number,
      );
      final result = await _authRepo.forgotPassword(method.name, number!);
      result.fold(
        (failure) => _setError(failure.message),
        (data) => state = state.copyWith(
          otpPhoneNumber: number,
          loadingState: Requestenum.success,
        ),
      );
    } catch (e) {
      _setError('forgot_password_request_failed');
    }
  }

  // Future<void> otpPasswordReset(String otp) async {
  //   if (state.currentScreenFlow == AuthCurrentScreenFlow.checkotp &&
  //       state.loadingState == Requestenum.loading) {
  //     return;
  //   }
  //   try {
  //     _setLoading(AuthCurrentScreenFlow.checkotp);
  //     final result = await _authRepo.otpPasswordReset(otp);
  //     result.fold(
  //       (failure) => _setError(failure.message),
  //       (data) => state = state.copyWith(
  //         otpCode: otp,
  //         loadingState: Requestenum.success,
  //       ),
  //     );
  //   } catch (e) {
  //     _setError('invalid_otp_try_again');
  //   }
  // }

  Future<void> passwordReset(String newPassword) async {
    if (state.currentScreenFlow == AuthCurrentScreenFlow.resetPassword &&
        state.loadingState == Requestenum.loading) {
      return;
    }
    if (state.otp == null) return;
    try {
      _setLoading(AuthCurrentScreenFlow.resetPassword);
      final result = await _authRepo.passwordReset(
        state.otp!.code!,
        newPassword,
      );
      result.fold(
        (failure) => _setError(failure.message),
        (data) => state = state.copyWith(
          // user: data,
          loadingState: Requestenum.success,
        ),
      );
    } catch (e) {
      _setError('password_reset_unexpected_failure');
    }
  }

  Future<void> logout(bool doLogoutRequest) async {
    try {
      _authRepo.logout(doLogoutRequest);
      ref.read(splashProvider.notifier).logout();
      state = AuthState.initial().copyWith(loadingState: Requestenum.success);
    } catch (e) {
      state = AuthState.initial();
    }
  }

  void setChronicDiseases(List<String> chronicDiseases) {}

  // Future<void> deleteAccount() async {
  //   state = state.copyWith(loadingState: Requestenum.loading);
  //   final result = await _authRepo.deleteAccount();
  //   result.fold((failure) {
  //     state = state.copyWith(
  //       loadingState: Requestenum.error,
  //       errorMessage: failure.message,
  //     );
  //   }, (data) {
  //     state = state.copyWith(
  //       loadingState: Requestenum.success,
  //     );
  //     logout(false);
  //   });
  // }
}
