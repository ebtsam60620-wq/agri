
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/splash/domain/repository/splash_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SplachRepo)
class SplashRepositoryImpl extends SplachRepo {
  SplashRepositoryImpl(super.remoteDataSource, super.localDataSource);

  @override
  @PostConstruct()
  void init() {
    final String? authToken = localDataSource.returnAuthToken()?.token;
    if (authToken != null) {
      remoteDataSource.saveToken(authToken);
    }
  }

  @override
  Future<Option<Failure, User>> getMe() async {
    final result = await remoteDataSource.getme();
    return result.fold((left) => left, (right) {
      localDataSource.saveUser(right);
      return right;
    });
  }

}
