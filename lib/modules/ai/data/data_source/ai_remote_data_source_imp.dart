import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/response_adapter.dart';
import 'package:agri/modules/ai/data/data_source/ai_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AiRemoteDataSource)
class AiRemoteDataSourceImp implements AiRemoteDataSource {
  AiRemoteDataSourceImp(this.httpInterface);

  late final HttpDataSource httpInterface;

  @override
  Future<Option<Failure, ResponseAdapter>> getAnalyses({
    int page = 1,
    int perPage = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'per_page': perPage,
    };

    final result = await httpInterface.get(
      url: '/analyses',
      queryParameters: queryParams,
    );
    return result.fold((l) => l, (r) => r);
  }
}
