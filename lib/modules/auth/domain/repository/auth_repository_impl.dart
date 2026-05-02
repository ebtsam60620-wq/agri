import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/utils/account_status_enum.dart';
import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';
import 'package:agri/modules/auth/data/models/auth_token.dart';
import 'package:agri/modules/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

//TODO: FCM Token
@LazySingleton(as: AuthRepo)
class AuthRepositoryImpl extends AuthRepo {
  AuthRepositoryImpl(super.remoteDataSource, super.localDataSource);

  @override
  @PostConstruct()
  void init() {
    final String? authToken = localDataSource.returnAuthToken()?.token;
    if (authToken != null) {
      remoteDataSource.saveToken(authToken);
    }
  }

  @override
  Future<Option<Failure, User>> signup({
    required RegisterFormDto registerFormDto,
    Function(int, int)? onSendProgress,
  }) async {
    // final fcmToken = (await FirebaseMessaging.instance.getToken()) ?? '';
    return await remoteDataSource
        .signup(
          registerFormDto: registerFormDto,
          onSendProgress: onSendProgress,
          fcmToken: "fcmToken",
        )
        .then(
          (e) => e.fold((left) => left, (right) {
            final token = ModelParser.parse(
              () => AuthToken.fromJson(right.data),
            );
            remoteDataSource.saveToken(token.token);
            final user = ModelParser.parse(
              () => User.fromJson(right.data['user']),
            );
            localDataSource.saveToken(token);
            saveUser(user);

            return user;
          }),
        );
  }

  @override
  Future<Option<Failure, DateTime>> sendCode(String type, String number) async {
    return await remoteDataSource.sendCode(type, number);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> forgotPassword(
    String type,
    String number,
  ) async {
    return await remoteDataSource.forgotPassword(type, number);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> verifyPhone(String otp , String email) async {
    final result = await remoteDataSource.verifyPhone(otp , email);
    return result.fold((left) => left, (right) {
      // final user = User.fromJson(right.data["data"]["user"]);
      // saveUser(user);
      saveUser(
        di.get<UserLocalDataSource>().returnUser()!.copyWith(isVerified: true),
      );
      return right;
    });
  }

  @override
  Future<Option<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    // final fcmToken = (await FirebaseMessaging.instance.getToken()) ?? '';
    final result = await remoteDataSource.login(
      email: email,
      password: password,
      fcmToken: "fcmToken",
    );
    return result.fold((left) => left, (right) {
      final token = ModelParser.parse(() => AuthToken.fromJson(right.data));
      remoteDataSource.saveToken(token.token);
      final user = ModelParser.parse(() => User.fromJson(right.data['user']));

      localDataSource.saveToken(token);
      saveUser(user);

      return user;
    });
  }

  @override
  Future<Option<Failure, ResponseAdapter>> passwordReset(
    String code,
    String newPassword,
  ) async {
    return await remoteDataSource.passwordReset(code, newPassword);
  }

  @override
  void saveUser(User user) {
    localDataSource.saveUser(user);
  }

  @override
  void logout(bool doLogoutRequest) async {
    // GoogleSignIn().signOut();
    // FacebookAuth.i.logOut();

    if (doLogoutRequest) {
      // final fcmToken = (await FirebaseMessaging.instance.getToken()) ?? '';
      await remoteDataSource.logout("fcmToken");
    }
    localDataSource.logOut();
  }

  // @override
  // Future<Option<Failure, dynamic>> acceptTerms(bool isProvider) async {
  //   final res = await remoteDataSource.acceptTerms();
  //   return res.fold((left) => left, (right) {
  //     final user = ModelParser.parse(
  //       () => User.fromJson(right.data['data'], isProvider: isProvider),
  //     );
  //     saveUser(user);
  //     return right;
  //   });
  // }

  // @override
  // Future<Option<Failure, dynamic>> acceptDisclaimer(bool isProvider) async {
  //   final res = await remoteDataSource.acceptDisclaimer();
  //   return res.fold((left) => left, (right) {
  //     final user = ModelParser.parse(
  //       () => User.fromJson(right.data['data'], isProvider: isProvider),
  //     );
  //     saveUser(user);
  //     return right;
  //   });
  // }

  //TODO: Change to content Only
  @override
  Future<Option<Failure, String>> getDisclaimer() async {
    final result = await remoteDataSource.getDisclaimer();
    return result.fold(
      (e) => e,
      (r) => ModelParser.parse(() => r.data['data']['contentEn']),
    );
  }

  //TODO: Change to content Only
  @override
  Future<Option<Failure, String>> getTerms() async {
    final result = await remoteDataSource.getTerms();
    return result.fold(
      (e) => e,
      (r) => ModelParser.parse(() => r.data['data']['contentEn']),
    );
  }
}
