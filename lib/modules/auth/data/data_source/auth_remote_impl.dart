import 'dart:developer';
import 'package:agri/core/configs/endpoints.dart';
import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/failure.dart' show Failure;
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/modules/auth/data/data_source/auth_remote_data_source.dart';
import 'package:agri/modules/auth/data/forms/register_form_dto.dart';
import 'package:agri/modules/auth/data/models/auth_token.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.httpInterface);

  late final HttpDataSource httpInterface;

  @override
  void saveToken(String token) {
    httpInterface.setToken(token);
  }

  @override
  Future<Option<Failure, ResponseAdapter>> signup({
    required RegisterFormDto registerFormDto,
    Function(int, int)? onSendProgress,

    required String fcmToken,
  }) async {
    final result = await httpInterface.post(
      onSendProgress: onSendProgress,
      url: EndPoints.signup,
      data: {
        ...registerFormDto.toJson(),

        // 'fcmToken': fcmToken,
      },
    );

    return result.fold((r) => r, (r) {
      return r;
    });
  }

  @override
  Future<Option<Failure, ResponseAdapter>> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final result = await httpInterface.post(
      url: EndPoints.login,
      data: {
        'email': email,
        'password': password,
        // 'fcmToken': fcmToken,
        // 'loginAs': userType.backendvalue,
      },
      // onCatch: (err) {
      //   DioException error = err as DioException;
      //   if (error.response == null) {
      //     return Left<Failure, ResponseAdapter>(
      //       Failure(errorMessages['ERR_NETWORK'], errorMessages['ERR_NETWORK']),
      //     );
      //   } else if (error.response!.data is Map) {
      //     final message = (error.response?.data['error'] as String).replaceAll(
      //       '_',
      //       ' ',
      //     );
      //     // .map((e) => (e['constraints'] as Map).values.join('\n'))
      //     // .join('\n');
      //     return Left<Failure, ResponseAdapter>(Failure(message, message));
      //   } else if (error.response!.data is String &&
      //       (error.response!.data as String).isNotEmpty) {
      //     return Left<Failure, ResponseAdapter>(
      //       Failure(error.response!.data, error.response!.data),
      //     );
      //   } else if (error.response!.isRedirect) {
      //     return Left<Failure, ResponseAdapter>(
      //       Failure('error Redirected', 'error Redirected'),
      //     );
      //   } else {
      //     return Left<Failure, ResponseAdapter>(Failure('error', 'error'));
      //   }
      // },
    );
    log(result.toString());
    return result.fold((l) => l, (r) {
      final AuthToken token = AuthToken.fromJson(r.data);
      saveToken(token.token);
      return r;
    });
  }

  @override
  Future<Option<Failure, ResponseAdapter>> verifyPhone(
    String otp,
    String email,
  ) async {
    final result = await httpInterface.post(
      url: EndPoints.verifyPhone,
      data: {'code': otp, 'email': email},
    );

    return result;
  }

  @override
  Future<Option<Failure, DateTime>> sendCode(String type, String number) async {
    final result = await httpInterface.post(
      url: EndPoints.sendOTPCode,
      data: {'type': type, type: number},
    );
    return result.fold((e) => e, (r) {
      return DateTime.now().add(Duration(seconds: 30));
    });
  }

  @override
  Future<Option<Failure, ResponseAdapter>> forgotPassword(
    String type,
    String number,
  ) async {
    final result = await httpInterface.post(
      url: EndPoints.forgotPassword,
      data: {'type': type, type: number},
    );
    return result;
  }

  @override
  Future<Option<Failure, ResponseAdapter>> passwordReset(
    String code,
    String newPassword,
  ) async {
    final result = await httpInterface.post(
      url: EndPoints.passwordReset,
      data: {'token': code, 'newPassword': newPassword},
    );

    return result;
  }

  @override
  Future<Option<Failure, ResponseAdapter>> logout(String fcmToken) async {
    final refreshToken = di<UserLocalDataSource>()
        .returnAuthToken()
        ?.refreshToken;
    if (refreshToken != null) {
      final result = await httpInterface.post(
        url: EndPoints.logout,
        data: {'fcmToken': fcmToken, 'refreshToken': refreshToken},
      );
      return result.fold((l) => l, (r) {
        httpInterface.deleteToken();
        return r;
      });
    } else {
      return Right(ResponseAdapter.empty());
    }
  }

  // @override
  // Future<Option<Failure, ResponseAdapter>> acceptTerms() async {
  //   final result = await httpInterface.post(url: EndPoints.acceptTerms);

  //   return result;
  // }

  // @override
  // Future<Option<Failure, ResponseAdapter>> acceptDisclaimer() async {
  //   final result = await httpInterface.post(url: EndPoints.acceptDisclaimer);
  //   return result;
  // }

  @override
  Future<Option<Failure, ResponseAdapter>> getDisclaimer() async {
    final result = await httpInterface.get(url: EndPoints.providerSpecialties);

    return result;
  }

  @override
  Future<Option<Failure, ResponseAdapter>> getTerms() async {
    final result = await httpInterface.get(url: EndPoints.providerSpecialties);

    return result;
  }
}
