import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/interfaces/abstract_http_data_source.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/domain/repository/auth_repository.dart';
import 'package:agri/modules/device_model/domain/repository/device_repo.dart';
import 'package:agri/modules/splash/domain/repository/splash_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'splash_states.dart';

class SplashNotifier extends Notifier<SplashStates> {
  SplashNotifier(
    this._splasrepo,
    this._userLocalDataSource,
    this._moduleRepository,
  );

  final UserLocalDataSource _userLocalDataSource;
  final DeviceModuleRepository _moduleRepository;

  @override
  SplashStates build() {
    final user = di<UserLocalDataSource>().returnUser();
    if (user != null) {
      Future.microtask(() => setUser(user));
    }
    return SplashStates.initial(user: user);
  }

  final SplachRepo _splasrepo;
  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  void logout() {
    state = SplashStates.initial();
  }

  Future<void> initializeApp() async {
    await getme();
    // if (state.splashEnum == SplashEnum.getme &&
    //     state.loadingState == Requestenum.success &&
    //     state.user != null) {
    //   await getdata();
    // }
  }

  Future<void> getme() async {
    final token = _userLocalDataSource.returnAuthToken();
    if (token == null) {
      state = state.copyWith(
        loadingState: Requestenum.success,
        splashEnum: SplashEnum.noAuth,
      );
      return;
    }
    if (token.canRefresh && token.isExpired) {
      await di<HttpDataSource>().refreshAccessToken();
    } else if (!token.canRefresh) {
      di<AuthRepo>().logout(false);
      state = SplashStates.initial();
      return;
    }

    state = state.copyWith(
      loadingState: Requestenum.loading,
      splashEnum: SplashEnum.getme,
    );
    final result = await _splasrepo.getMe();

    result.fold(
      (failure) async {
        if (failure.message == 'authentication required') {
          // _userLocalDataSource.logOut();
          await di<HttpDataSource>().refreshAccessToken();
          getme();
          if (state.splashEnum != SplashEnum.resetToken) {
            state = state.copyWith(splashEnum: SplashEnum.resetToken);
            return;
          }
        }
        state = state.copyWith(
          loadingState: Requestenum.error,
          errorMessage: failure.message,
        );
      },
      (user) async {
        // _userLocalDataSource.saveUser(user);
        await _moduleRepository.getMyModules();
        state = state.copyWith(loadingState: Requestenum.success, user: user);
      },
    );
  }

  Future<void> updateProfile({String? fullName, String? phone}) async {
    state = state.copyWith(loadingState: Requestenum.loading);
    final result = await _splasrepo.updateProfile(
      fullName: fullName,
      phone: phone,
    );

    result.fold(
      (failure) => state = state.copyWith(
        loadingState: Requestenum.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        loadingState: Requestenum.success,
        user: user,
      ),
    );
  }
}
