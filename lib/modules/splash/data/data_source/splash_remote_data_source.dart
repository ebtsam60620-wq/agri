import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/user.dart';

abstract class SpalshRemoteDataSource {
  SpalshRemoteDataSource();

  Future<Option<Failure, User>> getme();

  void saveToken(String token);
}
