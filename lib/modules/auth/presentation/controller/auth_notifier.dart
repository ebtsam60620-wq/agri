import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';
import 'package:agri/modules/auth/domain/repository/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'auth_states.dart';

class AuthNotifier extends Notifier<AuthState> {
  AuthNotifier(this._authRepo);

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

  Future<void> signup({required RegisterFormDto registerFormDto}) async {
    state = state.copyWith(
      loadingState: Requestenum.loading,
      currentScreenFlow: AuthCurrentScreenFlow.register,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.signup(registerFormDto: registerFormDto);
    result.fold(
      (left) {
        state = state.copyWith(
          loadingState: Requestenum.error,
          errorMessage: left.message,
        );
      },
      (right) {
        state = state.copyWith(user: right, loadingState: Requestenum.success);
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(
      currentScreenFlow: AuthCurrentScreenFlow.login,
      loadingState: Requestenum.loading,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.login(
      email: email,
      password: password,
      userType: state.userType,
    );
    result.fold(
      (failure) async {
        state = state.copyWith(
          loadingState: Requestenum.error,
          errorMessage: failure.message,
        );
      },
      (data) async {
        state = state.copyWith(user: data, loadingState: Requestenum.success);
      },
    );
  }

  Future<void> sendCode(String type, String number) async {
    state = state.copyWith(
      loadingState: Requestenum.loading,
      currentScreenFlow: AuthCurrentScreenFlow.enteringOTP,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.sendCode(type, number);
    result.fold(
      (failure) {
        state = state.copyWith(
          loadingState: Requestenum.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          loadingState: Requestenum.success,
          otpRequestedAt: data,
        );
      },
    );
  }

  Future<void> forgotPassword(String type, String number) async {
    state = state.copyWith(
      loadingState: Requestenum.loading,
      currentScreenFlow: AuthCurrentScreenFlow.forgotPassword,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.forgotPassword(type, number);
    result.fold(
      (failure) {
        state = state.copyWith(
          loadingState: Requestenum.error,
          errorMessage: failure.message,
        );
      },
      (ResponseAdapter data) {
        state = state.copyWith(
          loadingState: Requestenum.success,
          successMessage: data.data['data']['message'],
          resetToken: data.data['debugData']?['resetToken'] as String?,
        );
      },
    );
  }

  Future<void> verifyPhone(String otp) async {
    state = state.copyWith(
      currentScreenFlow: AuthCurrentScreenFlow.enteringOTP,
      loadingState: Requestenum.loading,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.verifyPhone(otp);
    result.fold(
      (failure) {
        state = state.copyWith(
          loadingState: Requestenum.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(loadingState: Requestenum.success);
      },
    );
  }

  Future<void> passwordReset(String token, String newPassword) async {
    state = state.copyWith(
      currentScreenFlow: AuthCurrentScreenFlow.resetPassword,
      loadingState: Requestenum.loading,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _authRepo.passwordReset(token, newPassword);
    result.fold(
      (failure) {
        state = state.copyWith(
          loadingState: Requestenum.error,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          loadingState: Requestenum.success,
          successMessage: data.data['data']['message'] as String? ?? 'Success',
        );
      },
    );
  }

  Future<void> logout(bool doLogoutRequest) async {
    _authRepo.logout(doLogoutRequest);
    state = AuthState.initial().copyWith(
      currentScreenFlow: AuthCurrentScreenFlow.logout,
      loadingState: Requestenum.success,
    );
  }
}
