import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';

abstract class AiRemoteDataSource {
  Future<Option<Failure, ResponseAdapter>> getAnalyses({
    int page = 1,
    int perPage = 20,
  });
}
