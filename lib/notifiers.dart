import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/modules/splash/presentation/controller/splash_notifier.dart';
import 'package:agri/presentation/components/my_scafold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(di(), di()),
  name: 'authProvider',
);

final layoutProvider = StateProvider.autoDispose<HomePages>((ref) {
  return HomePages.home;
}, name: 'layoutProvider');

final splashProvider = NotifierProvider<SplashNotifier, SplashStates>(
  () => SplashNotifier(di(), di()),
  name: 'splashProvider',
);

final loadingProvider = StateProvider.autoDispose<double>((ref) => 0.0);
