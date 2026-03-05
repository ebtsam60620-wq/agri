
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/data/models/auth_token.dart';

abstract class UserLocalDataSource {
  Future<void> init();

  void saveToken(AuthToken token);

  bool isAuthTokenExists();

  AuthToken? returnAuthToken();

  void saveUser(User user);

  bool isUserExists();

  User? returnUser();

  void logOut();
}
