import 'package:dio/dio.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';

abstract class HttpDataSource {
  void setToken(String token);

  void deleteToken();

  void setLanguageHeader({String? languageCode});

  Map<String, dynamic> get getHeaders;

  Future<Option<Failure, T>> get<T extends ResponseAdapter>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<T>? onCatch,
  });

  Future<Option<Failure, T>> post<T extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<T>? onCatch,
    Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  });

  Future<Option<Failure, T>> put<T extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<T>? onCatch,
  });

  Future<Option<Failure, T>> patch<T extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<T>? onCatch,
  });

  Future<Option<Failure, T>> delete<T extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    OnExcepCatch<T>? onCatch,
  });

  Future<Option<Failure, T>> customRequest<T extends ResponseAdapter>({
    required String url,
    required String method,
    Object? data,
    Map<String, dynamic>? headers,
    OnExcepCatch<T>? onCatch,
  });

  Future<Option<Failure, T>>
      requestStreamedResponseUsingDio<T extends ResponseAdapter>({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
    OnExcepCatch<T>? onCatch,
  });
}

typedef OnTryFuture<F> = Future<F> Function();
typedef OnExcepCatch<ResponseAdapter> = Option<Failure, ResponseAdapter>
    Function(Exception err);
