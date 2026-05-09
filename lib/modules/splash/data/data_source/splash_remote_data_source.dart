import 'package:agri/data/models/failure.dart';
import 'package:agri/data/models/option.dart';
import 'package:agri/data/models/user.dart';

abstract class SpalshRemoteDataSource {
  SpalshRemoteDataSource();

  Future<Option<Failure, User>> getme();

  Future<Option<Failure, User>> updateProfile({String? fullName, String? phone});

  void saveToken(String token);
}
