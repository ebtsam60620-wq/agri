import 'package:dio/dio.dart';

class ResponseAdapter {
  ResponseAdapter({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.headers,
    this.isStream = false,
  });

  factory ResponseAdapter.empty() {
    return ResponseAdapter(
      data: null,
      statusCode: null,
      statusMessage: null,
      headers: {},
    );
  }

  factory ResponseAdapter.fromDioResponse(Response response) {
    final isStreamedResponse =
        response.requestOptions.responseType == ResponseType.stream;
    return ResponseAdapter(
      data: isStreamedResponse
          ? (response.data as ResponseBody).stream
          : response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers.map,
      isStream: isStreamedResponse,
    );
  }

  final dynamic data;
  final int? statusCode;
  final String? statusMessage;
  final Map<String, dynamic> headers;
  final bool isStream;
}
