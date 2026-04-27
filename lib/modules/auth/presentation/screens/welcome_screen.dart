import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/resources/assets.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/modules/auth/presentation/widgets/auth_scaffold.dart';
import 'package:agri/presentation/components/my_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, this.signup = false});
  final bool signup;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'welcome',
      subTitle: 'World’s Smartest Farmer',
      bottomSubTitle: 'Have an account?',
      bottomSubEnd: 'Log in',
      onSub: () => RouteManager.goTo(RouteManager.login),
      body: Column(
        spacing: 20,
        children: [
          Expanded(
            child: Image.asset(
              Assets.pngWelcomeImage,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: child,
                  ),
            ),
          ),
          MyButton(
            onPressed: () => RouteManager.goTo(RouteManager.signUpUser),
            childWidget: Text(
              'Create Account',
              style: TextStyle(
                color: ColorsManager.textWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: MyButtonStyle.solid,
          ),
          MyButton(
            onPressed: () => RouteManager.goTo(RouteManager.login),
            childWidget: Text('Already Have An Account'),
            style: MyButtonStyle.liner,
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
