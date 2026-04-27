import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/data/models/auth_token.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart';
@LazySingleton(as: UserLocalDataSource)
final class ObjectboxUserStorageImpl extends UserLocalDataSource {
  late final Box<User> userBox;
  late final Box<AuthToken> tokenBox;

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final Store store = await openStore(
      directory: join(docsDir.path, 'objectbox-user'),
    );
    userBox = store.box<User>();
    tokenBox = store.box<AuthToken>();
  }

  @override
  void saveToken(AuthToken token) {
    tokenBox.removeAll();
    tokenBox.put(token);
  }

  @override
  bool isAuthTokenExists() {
    return tokenBox.getAll().isNotEmpty;
  }

  @override
  AuthToken? returnAuthToken() {
    return tokenBox.getAll().firstOrNull;
  }

  @override
  void saveUser(User user) {
    userBox.removeAll();
    userBox.put(user);
  }

  @override
  bool isUserExists() {
    return userBox.getAll().isNotEmpty;
  }

  @override
  User? returnUser() {
    final user = userBox.getAll().firstOrNull;
    return user;
  }

  @override
  void logOut() {
    tokenBox.removeAll();
    userBox.removeAll();
  }




}
