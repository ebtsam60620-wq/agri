import 'dart:developer';

import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:agri/data/models/user.dart';
import 'package:agri/modules/auth/presentation/screens/forget_password.dart';
import 'package:agri/modules/auth/presentation/screens/login_screen.dart';
import 'package:agri/modules/auth/presentation/screens/new_password_screen.dart';
import 'package:agri/modules/auth/presentation/screens/otp_screen.dart';
import 'package:agri/modules/auth/presentation/screens/signup_user_first_screen.dart';
import 'package:agri/modules/auth/presentation/screens/welcome_screen.dart';
import 'package:agri/modules/onboarding_screen/screens/onboarding_main.dart';
import 'package:agri/modules/splash/presentation/splash_screen.dart';
import 'package:agri/presentation/components/my_scafold.dart';
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

  static void firstScreen({User? user, bool goto = true}) async {
    user ??= di.get<UserLocalDataSource>().returnUser()!;
    void navigate(String route) {
      if (goto) {
        RouteManager.goTo(route);
      } else {
        RouteManager.replaceUntilOrAll(route);
      }
    }

    navigate(RouteManager.splash);
  }

  // splash
  static const String splash = '/';
  static const String welcome = '/welcome';

  //onboarding + Auth
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String otp = '/otp';
  static const String signUpUser = '/SignUpUser';
  static const String createNewPassword = '/createNewPassword';

  static const String terms = '/terms';


  static const String home = '/home';

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

          onPopInvokedWithResult: (didPop, result) async {
            final canp = canPop(context: context);
            final secounds = _firstPress?.difference(DateTime.now()).inSeconds;
            if (!canp && secounds != null && secounds.abs() < 5) {
              SystemNavigator.pop();
              return;
            } else {
              if (!canp) {
                _firstPress = DateTime.now();
                mySnackBar("pressAgainToCloseApp", context, isError: false);
              }
            }
          },
          child: switch (settings.name) {
            // Start and Auth
            splash => const SplashScreen(),
            welcome => const WelcomeScreen(),
            onboarding => const OnboardingMainScreen(),
            login => const LoginScreen(),
            forgotPassword => const ForgetPasswordScreen(),
            otp => const OtpVerificationScreen(),
            createNewPassword => const NewPasswordScreen(),
            signUpUser => const SignUpUserFirstScreen(),
            home=> const MyScafold(),
            _ => const SplashScreen(),
          },
        );
      },
    );
  };
}

typedef RouteHandler =
    Widget Function(RouteSettings settings, BuildContext context);
