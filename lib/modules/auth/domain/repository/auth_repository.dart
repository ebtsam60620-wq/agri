
import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/data/data_source/auth_remote_data_source.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';

abstract class AuthRepo {
  const AuthRepo(this.remoteDataSource, this.localDataSource);

  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  void init();

  Future<Option<Failure, User>> signup({
    required RegisterFormDto registerFormDto,
  });

  Future<Option<Failure, User>> login({
    required String email,
    required String password,
    required UserTypeEnum userType,
  });

  // Future<Option<Failure, AuthToken>> guestLogin();

  // Future<Option<Failure, AuthDecisionModel>> googleLogin({
  //   required bool isSignUp,
  //   required bool rememberMe,
  // });

  // Future<Option<Failure, AuthDecisionModel>> facebookLogin({
  //   required bool isSignUp,
  //   required bool rememberMe,
  // });
  Future<Option<Failure, DateTime>> sendCode(String type, String number);

  Future<Option<Failure, ResponseAdapter>> forgotPassword(
      String type, String number);

  // Future<Option<Failure, Null>> resendCode();

  // Future<Option<Failure, Null>> verifyEmail(String otp);

  // Future<Option<Failure, Null>> otp2FA(String otp);

  // Future<Option<Failure, Null>> forgotPassword(String email);

  // Future<Option<Failure, Null>> otpPasswordReset(String otp);
  Future<Option<Failure, ResponseAdapter>> verifyPhone(String otp);
  Future<Option<Failure, ResponseAdapter>> passwordReset(
      String code, String newPassword);

  void saveUser(User user);

  void logout(bool doLogoutRequest);
  Future<Option<Failure, dynamic>> acceptTerms(bool isProvider);
  Future<Option<Failure, dynamic>> acceptDisclaimer(bool isProvider);

  // Future<Option<Failure, bool>> deleteAccount();

  Future<Option<Failure, String>> getTerms();
  Future<Option<Failure, String>> getDisclaimer();
}
