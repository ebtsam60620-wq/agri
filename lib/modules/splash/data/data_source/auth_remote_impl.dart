import 'dart:developer';
import 'package:agri/core/configs/endpoints.dart';
import 'package:agri/core/utils/model_parser.dart';
import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/splash/data/data_source/splash_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SpalshRemoteDataSource)
class SplashRemoteDataSourceImpl extends SpalshRemoteDataSource {
  SplashRemoteDataSourceImpl(this.httpInterface);

  late final HttpDataSource httpInterface;

  @override
  void saveToken(String token) {
    httpInterface.setToken(token);
  }

  @override
  Future<Option<Failure, User>> getme() async {
    final result = await httpInterface.get(url: EndPoints.getme);
    log(result.toString());
    return result.fold((l) => l, (r) {
      return ModelParser.parse(() => User.fromJson(r.data['data'] ??r.data['user'] ));
    });
  }
}
