part of 'splash_notifier.dart';

class SplashStates {
  final LoadingStateEnum loadingState;
  final String? errorMessage;
  final String? successMessage;
  final User? user;
  final SplashEnum splashEnum;
  const SplashStates({
    required this.loadingState,
    this.successMessage,
    this.errorMessage,
    this.user,
    this.splashEnum = SplashEnum.init,
  });

  factory SplashStates.initial() {
    return const SplashStates(loadingState: LoadingStateEnum.initial);
  }

  SplashStates copyWith({
    LoadingStateEnum? loadingState,
    String? errorMessage,
    String? successMessage,
    User? user,
    SplashEnum? splashEnum,
  }) {
    return SplashStates(
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage,
      successMessage: successMessage ?? this.successMessage,
      user: user ?? this.user,
      splashEnum: splashEnum ?? this.splashEnum,
    );
  }

  @override
  String toString() {
    return 'SplashStates('
        'loadingState: $loadingState, '
        'errorMessage: $errorMessage'
        ', successMessage: $successMessage';
  }
}

enum SplashEnum { init, getme, getdata, noAuth, uploadAvatar, deleteAccount }
