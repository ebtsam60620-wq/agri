import 'dart:io';
import 'package:dio/dio.dart';
import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/device_model/data/data_source/ai_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AiRemoteDataSource)
class AiRemoteDataSourceImp implements AiRemoteDataSource {
  AiRemoteDataSourceImp(this.httpInterface);

  late final HttpDataSource httpInterface;

  @override
  Future<Option<Failure, Map<String, dynamic>>> analyzeImage({
    required int moduleId,
    required File imageFile,
  }) async {
    final fileName = imageFile.path.split('/').last;
    final formData = FormData.fromMap({
      'module_id': moduleId,
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    final result = await httpInterface.post(
      url: '/ai/analyze',
      data: formData,
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> getAnalyses({
    int page = 1,
    int perPage = 20,
  }) async {
    final result = await httpInterface.get(
      url: '/ai/analyses',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> getAnalysis(int analysisId) async {
    final result = await httpInterface.get(
      url: '/ai/analyses/$analysisId',
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }

  @override
  Future<Option<Failure, Map<String, dynamic>>> getModuleAnalyses({
    required int moduleId,
    int page = 1,
    int perPage = 20,
  }) async {
    final result = await httpInterface.get(
      url: '/ai/modules/$moduleId/analyses',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }
}
