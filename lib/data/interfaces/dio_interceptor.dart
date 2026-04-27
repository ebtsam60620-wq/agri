import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('Request: ${options.method} ${options.uri} \n ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('Response: ${response.statusCode} ${response.requestOptions.uri} \n ${json.encode(response.data)}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('Error from dio interceptor : ${err.response?.statusCode} ${err.requestOptions.uri} \n ${err.response?.data}');
    super.onError(err, handler);
  }
}
