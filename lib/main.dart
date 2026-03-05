import 'dart:async';
import 'dart:developer';
import 'package:agri/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/presentation/app_size_config.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: 'agri',
        primaryColor: ColorsManager.primary.hex,
      ),
    );

    await Future.wait([
      configureDependencies(),
     
    ]);

    if (!kDebugMode) {
     
    }
    runApp(const MyApp());
  }, (error, stack) {
    if (!kDebugMode) {
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      //  observers: [RiverPodNotifiersObserver()],
      child: RootOfApp(),
    );
  }
}

class RootOfApp extends ConsumerWidget {
  const RootOfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final localizationCode = ref.watch(localizationProvider);
    log('Localization code: en');
    return MaterialApp(
      title: 'agri',
      debugShowCheckedModeBanner: false,
      // theme: localizationCode == 'ar' ? arabicThemeData : englishThemeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale("en"),
      navigatorKey: RouteManager.navigatorKey,
      onGenerateRoute: RouteManager.onGenerateGlobalRoute,
      builder: (context, child) {
        // myTranslator = AppLocalizations.of(context);
        AppSizeConfig().init(context);
        return MediaQuery(
          key: ValueKey("en"),
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(
              1.0,
            ),
          ),
          child: SafeArea(
            top: false,
            child: child!,
          ),
        );
      },
    );
  }
}

class RiverPodNotifiersObserver extends ProviderObserver {
  const RiverPodNotifiersObserver();

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    log('${provider.runtimeType} ${provider.name} added');
    super.didAddProvider(provider, value, container);
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    log('${provider.runtimeType} ${provider.name} updated ,\n old value: $previousValue,\n new value: $newValue');
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    log('${provider.runtimeType} ${provider.name} disposed');
    super.didDisposeProvider(provider, container);
  }
}
