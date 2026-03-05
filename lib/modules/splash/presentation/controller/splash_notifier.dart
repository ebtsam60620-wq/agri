import 'package:agri/core/utils/loading_state_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/splash/domain/repository/splash_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'splash_states.dart';

class SplashNotifier extends AutoDisposeNotifier<SplashStates> {
  SplashNotifier(this._authRepo, this._userLocalDataSource);
  final UserLocalDataSource _userLocalDataSource;

  @override
  SplashStates build() {
    Future.microtask(() => initializeApp());
    return SplashStates.initial();
  }

  final SplachRepo _authRepo;
  Future<void> initializeApp() async {
    await getme();
    if (state.splashEnum == SplashEnum.getme &&
        state.loadingState == LoadingStateEnum.success &&
        state.user != null) {
    }
  }

  Future<void> getme() async {
    if (!_userLocalDataSource.isAuthTokenExists()) {
      state = state.copyWith(
        loadingState: LoadingStateEnum.success,
        splashEnum: SplashEnum.noAuth,
      );
      return;
    }
    state = state.copyWith(
      loadingState: LoadingStateEnum.loading,
      splashEnum: SplashEnum.getme,
    );
    final result = await _authRepo.getMe();

    result.fold(
      (failure) {
        if (failure.message == 'authentication required') {
          _userLocalDataSource.logOut();
        }
        state = state.copyWith(
          loadingState: LoadingStateEnum.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        // _userLocalDataSource.saveUser(user);
        state = state.copyWith(
          loadingState: LoadingStateEnum.success,
          user: user,
        );
      },
    );
  }
}
