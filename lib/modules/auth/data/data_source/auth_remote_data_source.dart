import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';

abstract class AuthRemoteDataSource {
  AuthRemoteDataSource();

  void saveToken(String token);

  Future<Option<Failure, dynamic>> signup({
    required RegisterFormDto registerFormDto,
    Function(int, int)? onSendProgress,
      
    required String fcmToken,
  });

  Future<Option<Failure, dynamic>> login({
    required String email,
    required String password,
    required String fcmToken,
  });

  Future<Option<Failure, ResponseAdapter>> verifyPhone(String otp, String email);

  // Future<Option<Failure, B>> otp2FA(String otp);

  Future<Option<Failure, DateTime>> sendCode(String type, String number);
  Future<Option<Failure, ResponseAdapter>> forgotPassword(
    String type,
    String number,
  );

  // Future<Option<Failure, B>> resendCode();

  // Future<Option<Failure, B>> forgotPassword(String email);

  // Future<Option<Failure, B>> otpPasswordReset(String otp);

  Future<Option<Failure, ResponseAdapter>> passwordReset(
    String code,
    String newPassword,
  );

  Future<Option<Failure, dynamic>> logout(String fcmToken);
  // Future<Option<Failure, dynamic>> acceptTerms();
  // Future<Option<Failure, dynamic>> acceptDisclaimer();

  // Future<Option<Failure, B>> deleteAccount();

  // Provider


  Future<Option<Failure, ResponseAdapter>> getTerms();
  Future<Option<Failure, ResponseAdapter>> getDisclaimer();
}
