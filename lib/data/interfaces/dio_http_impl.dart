import 'dart:async';
import 'dart:io';

import 'package:agri/core/configs/endpoints.dart';
import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/data/data_sources/localization_local_data_source.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/interfaces/dio_interceptor.dart';
import 'package:agri/data/interfaces/error_code_mapper.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/modules/auth/data/models/auth_token.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HttpDataSource)
class DioHttpImpl extends HttpDataSource {
  late final Dio defaultServerDio;

  DioHttpImpl() {
    defaultServerDio = Dio(BaseOptions(
        sendTimeout: const Duration(seconds: 60),
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        baseUrl: EndPoints.baseURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    defaultServerDio.interceptors.add(DioInterceptor());
    setLanguageHeader();
  }

  @override
  void setToken(String token) {
    defaultServerDio.options.headers.addAll({'Authorization': 'Bearer $token'});
  }

  @override
  void deleteToken() {
    defaultServerDio.options.headers.remove('Authorization');
  }

  @override
  void setLanguageHeader({String? languageCode}) {
    languageCode ??=
        di.get<LocalizationLocalDataSource>().getLocalization().languageCode;
    defaultServerDio.options.headers.addAll({'Accept-Language': languageCode});
  }

  @override
  Map<String, dynamic> get getHeaders => defaultServerDio.options.headers;

  Future<Option<Failure, A>> _handleRequest<A extends ResponseAdapter>({
    required OnTryFuture<Response> onTry,
    OnExcepCatch<A>? onCatch,
  }) async {
    try {
      final response = await onTry();

      return Right(ResponseAdapter.fromDioResponse(response));
    } on DioException catch (error) {
      if (onCatch != null) {
        return onCatch(error);
      } else {
        return _defaultOnCatch(onTry, error);
      }
    } on SocketException {
      final message = errorMessages['ERR_NETWORK']!;

      return Left(Failure(message, message));
    }
  }

  Future<Option<Failure, bool>> _updateExpiredToken() async {
    try {
      final userDataSource = di<UserLocalDataSource>();
      final AuthToken? authToken = userDataSource.returnAuthToken();
      if (authToken != null) {
        final response = await defaultServerDio.post(EndPoints.updateToken,
            data: {'refreshToken': authToken.refreshToken});
        final newAuthToken = AuthToken.fromJson(response.data);
        userDataSource.saveToken(newAuthToken);
        setToken(newAuthToken.token);
        return Right(true);
      } else {
        return Right(false);
      }
    } catch (e) {
      return Left(Failure(e.toString(), e.toString()));
    }
  }

  Future<Option<Failure, A>> _defaultOnCatch<A extends ResponseAdapter>(
      OnTryFuture onTry, DioException error) async {
    String message = '';
    if (error.response?.data != null) {
      message = error.response!.data['error'].toString().replaceAll('_', ' ');
      return Left(Failure(message, error.message ?? ''));
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      message = errorMessages['TIMEOUT']!;
      return Left(Failure(message, message));
    } else if (error.error is SocketException) {
      message = errorMessages['ERR_NETWORK']!;
      return Left(Failure(message, message));
    } else if (error.response?.statusCode == 500) {
      message = errorMessages[500];
      return Left(Failure(message, message));
    } else if (error.response?.statusCode == 401 ||
        error.response?.statusCode == 403) {
      final updateTokenResult = await _updateExpiredToken();
      if (updateTokenResult.isRight) {
        final isUpdated = updateTokenResult.right;
        if (isUpdated ?? false) {
          try {
            final response = await onTry();
            return Right(ResponseAdapter.fromDioResponse(response));
          } catch (e) {
            return Left(Failure(e.toString(), e.toString()));
          }
        }
      } else if (updateTokenResult.isLeft) {
        di<UserLocalDataSource>().logOut();
        deleteToken();
        RouteManager.replaceUntilOrAll(RouteManager.login);
        message = errorMessages[error.response!.statusCode];
        return Left(Failure(message, message));
      }
    }
    try {
      if (error.response == null ||
          error.response?.data == null ||
          (error.response?.data['detail'] == null ||
              error.response?.data['message'] == null)) {
        message = error.message ?? 'An error occurred, please try again later.';
      } else {
        message = error.response!.data['response']['error_description'] ??
            error.response!.data['message'] ??
            error.response!.data['detail'] ??
            error.message ??
            errorMessages[error.response!.statusCode]!;
      }
    } catch (e) {
      message = error.message!;
    }
    if (error.response?.data != null) {
      message = error.response!.data['message'];
    }
    return Left(Failure(message, error.message ?? ''));
  }

  @override
  Future<Option<Failure, A>> get<A extends ResponseAdapter>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<A>? onCatch,
  }) async {
    final newQueryParameters = queryParameters
      ?..removeWhere((key, value) => value == null);
    final requestHeaders = {...getHeaders};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    return await _handleRequest(
      onCatch: onCatch,
      onTry: () {
        return defaultServerDio.get(url,
            queryParameters: newQueryParameters,
            options: Options(headers: requestHeaders));
      },
    );
  }

  @override
  Future<Option<Failure, A>> post<A extends ResponseAdapter>(
      {required String url,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      OnExcepCatch<A>? onCatch,
      CancelToken? cancelToken,
      Function(int, int)? onSendProgress}) async {
    final newQueryParameters = queryParameters
      ?..removeWhere((key, value) => value == null);
    final requestHeaders = {...getHeaders};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    return await _handleRequest(
      onCatch: onCatch,
      onTry: () {
        return defaultServerDio.post(url,
            data: data,
            cancelToken: cancelToken,
            queryParameters: newQueryParameters,
            onSendProgress: onSendProgress,
            options: Options(headers: requestHeaders));
      },
    );
  }

  @override
  Future<Option<Failure, A>> put<A extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<A>? onCatch,
  }) async {
    final newQueryParameters = queryParameters
      ?..removeWhere((key, value) => value == null);
    final requestHeaders = {...getHeaders};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    return await _handleRequest(
      onCatch: onCatch,
      onTry: () {
        return defaultServerDio.put(url,
            data: data,
            queryParameters: newQueryParameters,
            options: Options(headers: requestHeaders));
      },
    );
  }

  @override
  Future<Option<Failure, A>> patch<A extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<A>? onCatch,
  }) async {
    final newQueryParameters = queryParameters
      ?..removeWhere((key, value) => value == null);
    final requestHeaders = {...getHeaders};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    return await _handleRequest(
      onCatch: onCatch,
      onTry: () {
        return defaultServerDio.patch(url,
            data: data,
            queryParameters: newQueryParameters,
            options: Options(headers: requestHeaders));
      },
    );
  }

  @override
  Future<Option<Failure, A>> delete<A extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<A>? onCatch,
  }) async {
    final newQueryParameters = queryParameters
      ?..removeWhere((key, value) => value == null);
    final requestHeaders = {...getHeaders};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    return await _handleRequest(
      onCatch: onCatch,
      onTry: () {
        return defaultServerDio.delete(url,
            data: data,
            queryParameters: newQueryParameters,
            options: Options(headers: requestHeaders));
      },
    );
  }

  @override
  Future<Option<Failure, A>> customRequest<A extends ResponseAdapter>({
    required String url,
    required String method,
    Object? data,
    Map<String, dynamic>? headers,
    OnExcepCatch<A>? onCatch,
  }) async {
    final requestHeaders = {...getHeaders};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    return await _handleRequest(
        onCatch: onCatch,
        onTry: () {
          return defaultServerDio.requestUri(Uri.parse(url),
              data: data,
              options: Options(method: method, headers: requestHeaders));
        });
  }

  @override
  Future<Option<Failure, A>>
      requestStreamedResponseUsingDio<A extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    OnExcepCatch<A>? onCatch,
  }) async {
    late OnTryFuture onTry;
    try {
      final newQueryParameters = queryParameters
        ?..removeWhere((key, value) => value == null);
      onTry = () {
        return defaultServerDio.request(
          url,
          data: data,
          queryParameters: newQueryParameters,
          options: Options(
            responseType: ResponseType.stream,
            headers: {
              ...getHeaders,
              'Accept': 'text/event-stream',
              'Content-Type': 'application/json',
            },
          ),
        );
      };
      final response = await onTry();
      return Right(response);
    } on DioException catch (error) {
      if (onCatch != null) {
        return onCatch(error);
      } else {
        return _defaultOnCatch(onTry, error);
      }
    } on SocketException catch (error) {
      String message = '';
      message = error.message;
      return Left(Failure(message, error.message));
    } catch (e) {
      return Left(Failure(e.toString(), e.toString()));
    }
  }
}
