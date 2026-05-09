import 'dart:io';

import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';

abstract class AiRemoteDataSource {
  Future<Option<Failure, Map<String, dynamic>>> analyzeImage({
    required int moduleId,
    required File imageFile,
  });

  Future<Option<Failure, Map<String, dynamic>>> getAnalyses({
    int page = 1,
    int perPage = 20,
  });

  Future<Option<Failure, Map<String, dynamic>>> getAnalysis(int analysisId);

  Future<Option<Failure, Map<String, dynamic>>> getModuleAnalyses({
    required int moduleId,
    int page = 1,
    int perPage = 20,
  });
}
