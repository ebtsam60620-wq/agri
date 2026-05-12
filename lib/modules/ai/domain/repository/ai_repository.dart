import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';

abstract class AiRepository {
  Future<Option<Failure, Map<String, dynamic>>> getAnalyses({
    int page = 1,
    int perPage = 20,
  });
}
