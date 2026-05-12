import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/modules/auth/presentation/controller/auth_notifier.dart';
import 'package:agri/modules/device_model/presentation/controller/device_controller.dart';
import 'package:agri/modules/splash/presentation/controller/splash_notifier.dart';
import 'package:agri/modules/crop_cycle/presentation/controller/crop_cycle_controller.dart';
import 'package:agri/modules/device_model/presentation/controller/field_conditions_controller.dart';
import 'package:agri/modules/notification/presentation/controller/notification_controller.dart';
import 'package:agri/modules/notification/presentation/controller/notification_state.dart';
import 'package:agri/modules/ai/presentation/controller/ai_controller.dart';
import 'package:agri/modules/ai/presentation/controller/ai_state.dart';
import 'package:agri/presentation/components/my_scafold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(di(), di(), di()),
  name: 'authProvider',
);

final layoutProvider = StateProvider.autoDispose<HomePages>((ref) {
  return HomePages.home;
}, name: 'layoutProvider');

final splashProvider = NotifierProvider<SplashNotifier, SplashStates>(
  () => SplashNotifier(di(), di(), di()),
  name: 'splashProvider',
);

final device = NotifierProvider.autoDispose<DeviceController, DeviceState>(
  () => DeviceController(di()),
  name: 'device',
);

final cropCycleProvider = NotifierProvider.autoDispose<CropCycleController, CropCycleState>(
  () => CropCycleController(di()),
  name: 'cropCycleProvider',
);

final fieldConditionsProvider = NotifierProvider.autoDispose<FieldConditionsController, FieldConditionsState>(
  () => FieldConditionsController(di()),
  name: 'fieldConditionsProvider',
);

final notificationProvider = NotifierProvider.autoDispose<NotificationController, NotificationState>(
  () => NotificationController(di()),
  name: 'notificationProvider',
);

final loadingProvider = StateProvider.autoDispose<double>((ref) => 0.0);

final aiProvider = NotifierProvider.autoDispose<AiController, AiState>(
  () => AiController(di()),
  name: 'aiProvider',
);
