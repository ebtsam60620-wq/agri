import 'package:agri/core/infrastructure/di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

//dart run build_runner build

final di = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  asExtension: true,
)
Future<void> configureDependencies() => di.init();
