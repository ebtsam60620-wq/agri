import 'dart:developer';

import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/utils/account_status_enum.dart';
import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/presentation/screens/login.dart';
import 'package:agri/modules/onboarding_screen/presentation/onboarding_screen.dart';
import 'package:agri/modules/splash/presentation/splash_screen.dart';
import 'package:agri/presentation/components/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RouteManager {
  RouteManager._();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<dynamic> goTo(
    String routeName, {
    GlobalKey<NavigatorState>? navKey,
    Object? arguments,
  }) async {
    if (navKey == null) {
      return await navigatorKey.currentState!.pushNamed(
        routeName,
        arguments: arguments,
      );
    } else {
      return await navKey.currentState!.pushNamed(
        routeName,
        arguments: arguments,
      );
    }
  }

  static Future<dynamic> replace(
    String routeName, {
    GlobalKey<NavigatorState>? navKey,
    Object? arguments,
  }) async {
    if (navKey == null) {
      return await navigatorKey.currentState!.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    } else {
      return await navKey.currentState!.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    }
  }

  static Future<dynamic> replaceUntilOrAll(
    String routeName, {
    GlobalKey<NavigatorState>? navKey,
    String? until,
    Object? arguments,
  }) async {
    if (navKey == null) {
      return await navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName,
        (route) {
          if (until != null) {
            return route.settings.name == until;
          } else {
            return false;
          }
        },
        arguments: arguments,
      );
    } else {
      return await navKey.currentState!.pushNamedAndRemoveUntil(routeName, (
        route,
      ) {
        if (until != null) {
          return route.settings.name == until;
        } else {
          return false;
        }
      }, arguments: arguments);
    }
  }

  static void popUntil(String? routeName, {GlobalKey<NavigatorState>? navKey}) {
    if (navKey == null) {
      navigatorKey.currentState!.popUntil((route) {
        if (routeName != null) {
          return route.settings.name == routeName;
        } else {
          return false;
        }
      });
    } else {
      navKey.currentState!.popUntil((route) {
        if (routeName != null) {
          return route.settings.name == routeName;
        } else {
          return false;
        }
      });
    }
  }

  static void pop({Object? result, GlobalKey<NavigatorState>? navKey}) {
    if (navKey == null) {
      navigatorKey.currentState!.pop(result);
    } else {
      navKey.currentState!.pop(result);
    }
  }

  static bool canPop({required BuildContext? context}) {
    final con = context ?? navigatorKey.currentContext!;
    return ModalRoute.of(con)?.canPop ?? false;
    // if (navKey == null) {
    //   final route = ModalRoute.of(navigatorKey.currentContext!).isFirst;

    // return navigatorKey.currentState!.canPop();
    // } else {
    // return navKey.currentState!.canPop();
    // }
  }

  static void firstScreen({
    User? user,
    UserTypeEnum? requestsrole,
    bool goto = true,
  }) async {
    //TODO: error when user is provider and status is pending
    user ??= di.get<UserLocalDataSource>().returnUser()!;

    void navigate(String route) {
      if (goto) {
        RouteManager.goTo(route);
      } else {
        RouteManager.replaceUntilOrAll(route);
      }
    }

    if (requestsrole == UserTypeEnum.provider || user.isProvider) {
      if ((user.firstRequestStatus == null)) {
        navigate(RouteManager.signupProviderSecoundScreen);
      } else if (user.phoneVerifiedAt == null) {
        navigate(RouteManager.otp);
      } else if (user.firstRequestStatus?.toLowerCase() ==
          AccountStatusEnum.pending.name) {
        // AuthSuccessDialog.show(navigatorKey.currentContext!);
      } else if (user.firstRequestStatus?.toLowerCase() ==
          AccountStatusEnum.approved.name) {
        navigate(RouteManager.providerHomeScreen);
      }
    } else {
      if ((user.patientDetailsComplete ?? false) == false) {
        navigate(RouteManager.signupUserData);
      } else if (user.phoneVerifiedAt == null) {
        navigate(RouteManager.otp);
      } else {
        navigate(RouteManager.userHomeScreen);
      }
    }
  }

  static const String splash = '/';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String otp = '/otp';
  static const String signupUserData = '/signupUserData';
  static const String signUpUserFirstScreen = '/SignUpUserFirstScreen';
  static const String createNewPassword = '/createNewPassword';
  static const String selectUserType = '/selectUserType';
  static const String signupUserMedicalDataScreen =
      '/signupUserMedicalDataScreen';

  static const String terms = '/terms';
  static const String signupProviderSelectMedicalType =
      '/signupProviderSelectMedicalType';
  static const String signupProviderFirstScreen = '/signupProviderFirstScreen';
  static const String signupProviderSecoundScreen =
      '/signupProviderSecoundScreen';
  static const String signupProviderThirdScreen = '/signupProviderThirdScreen';
  static const String disclaimer = '/disclaimer';
  static const String providerHomeScreen = '/providerHomeScreen';
  static const String userHomeScreen = '/userHomeScreen';
  static const String userServiceScreen = '/userServiceScreen';
  static const String userServiceSelectProvidor = '/userServiceSelectProvidor';
  static const String userSeviceProvidorInfo = '/userSeviceProvidorInfo';
  static const String userTrackingServiceScreen = '/userTrackingServiceScreen';
  static const String userSubmitServiceScreen = '/userSubmitServiceScreen';

  static const String userCalcScreen = '/userCalcScreen';
  static const String userWaterScreen = '/userWaterScreen';
  static const String userBMIScreen = '/userBMIScreen';
  static const String userIBWScreen = '/userIBWScreen';
  static const String userSpO2Screen = '/userSpO\u2082Screen';

  static const String userServiceProviderReivews =
      '/userServiceProviderReivews';
  static const String userUserServiceHistoryScreen =
      '/userUserServiceHistoryScreen';
  static const String profileGeneralInformationScreen =
      '/ProfileGeneralInformationScreen';
  static const String profileChooseLanguageScreen =
      '/ProfileChooseLanguageScreen';
  static const String profileSavedProvidersScreen =
      '/ProfileSavedProvidersScreen';
  static const String profileSettingScreen = '/ProfileSettingScreen';
  static const String profileSupportScreen = '/ProfileSupportScreen';
  static const String profileAboutScreen = '/ProfileAboutScreen';
  static const String profileUserDataScreen = '/ProfileUserDataScreen';
  static const String profileUserDataImageScreen =
      '/ProfileUserDataImageScreen';
  static const String profileProviderDataImageScreen =
      '/ProfileProviderDataImageScreen';
  static const String profileProviderDataScreen = '/ProfileProviderDataScreen';
  static const String addressScreen = '/AddressScreen';
  static const String addressAddScreen = '/AddressAddScreen';
  static const String addressEditScreen = '/AddressEditScreen';
  static const String requestHistoryScreen = 'requestHistoryScreen';
  static const String providerSubmitServiceScreen =
      'ProviderSubmitServiceScreen';
  static const String userDetailsScreen = 'UserDetailsScreen';
  static const String chatScreen = '/chatScreen';

  // static const String userCureentServiceScreen = '/userCureentServiceScreen';
  static const String wallet = '/wallet';
  static const String withdraw = '/withdraw';
  static const String recentTransaction = '/resenttransactionscreen';
  static const String notification = '/notification';
  static const String chatsList = '/chatsList';
  static const String serviceScreen = '/serviceScreen';
  static const String addEditNewService = '/addEditNewService';
  static const String roshetadetailsscreen = '/roshetadetailsscreen';
  // static const String patientSessionDetailsPage = '/patientSessionDetailsPage';

  static DateTime? _firstPress;
  static Route<dynamic>? Function(RouteSettings)?
  onGenerateGlobalRoute = (settings) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.ease;
        final tween = Tween(begin: 0.0, end: 1.0);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return FadeTransition(
          opacity: tween.animate(curvedAnimation),
          child: child,
        );
      },
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        log(
          'Navigating to ${settings.name} with arguments ${settings.arguments} and can Pop is ${canPop(context: context)}',
        );

        return PopScope(
          canPop: canPop(context: context),
          //||
          //(_firstPress != null &&
          //                    _firstPress!.difference(DateTime.now()).inSeconds < 5)
          onPopInvokedWithResult: (didPop, result) async {
            final canp = canPop(context: context);
            final secounds = _firstPress?.difference(DateTime.now()).inSeconds;
            if (!canp && secounds != null && secounds.abs() < 5) {
              SystemNavigator.pop();
              return;
            } else {
              if (!canp) {
                _firstPress = DateTime.now();
                mySnackBar(
                  "AppLocalizations.of(context).pressAgainToCloseApp",
                  context,
                  isError: false,
                );
              }
            }
          },
          child:
              switch (settings.name) {
                    splash => const SplashScreen(),
                    onboarding => const OnboardingScreen(),
                    login => const LoginScreen(),
                    _ => const SplashScreen(),
                  }
                  as Widget,
        );
      },
    );
    //   if (Platform.isAndroid) {
    //     return MaterialPageRoute(
    //       settings: settings,
    //       builder: globalRoutes[settings.name]!,
    //     );
    //   } else {
    //     return CupertinoPageRoute(
    //       settings: settings,
    //       builder: globalRoutes[settings.name]!,
    //     );
    //   }
  };
}

typedef RouteHandler =
    Widget Function(RouteSettings settings, BuildContext context);
