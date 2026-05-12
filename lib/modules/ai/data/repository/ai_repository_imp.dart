import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/modules/ai/data/data_source/ai_remote_data_source.dart';
import 'package:agri/modules/ai/domain/repository/ai_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AiRepository)
class AiRepositoryImp implements AiRepository {
  AiRepositoryImp(this.remoteDataSource);

  final AiRemoteDataSource remoteDataSource;

  @override
  Future<Option<Failure, Map<String, dynamic>>> getAnalyses({
    int page = 1,
    int perPage = 20,
  }) async {
    final result = await remoteDataSource.getAnalyses(
      page: page,
      perPage: perPage,
    );
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => r.data as Map<String, dynamic>);
    });
  }
}
