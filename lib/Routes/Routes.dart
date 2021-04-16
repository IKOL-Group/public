import 'package:flutter/material.dart';
import 'package:public_app/main.dart';
import 'package:public_app/screens/Auth/ChangePassword.dart';
import 'package:public_app/screens/Auth/ChooseAuthType.dart';
import 'package:public_app/screens/Auth/LogInScreen/LoginPage.dart';
import 'package:public_app/screens/Auth/RegisterScreen/OTPVerification.dart';
import 'package:public_app/screens/Auth/RegisterScreen/RegisterPage.dart';
import 'package:public_app/screens/OnBoardingScreens/OnBoardingScreens.dart';
import 'package:public_app/screens/help.dart';
import 'package:public_app/screens/profile/profile.dart';

class Routes {
  static const String onBoarding = '/';
  static const String authValidation = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerify = '/otpVerify';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String help = '/help';
  static const String changePassword = '/changePassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case onBoarding:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case otpVerify:
        if (args != null && args is String) {
          return MaterialPageRoute(
            builder: (_) => OTPVerification(args),
          );
        }
        return null;
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case help:
        return MaterialPageRoute(builder: (_) => HelpPage());
      case changePassword:
        return MaterialPageRoute(builder: (_) => ChangePassword());
      case authValidation:
        // Validation of correct data type
        if (args != null && args is String) {
          return MaterialPageRoute(
            builder: (_) => HomeScreen(
              token: args,
            ),
          );
        }
        // If args is not of the correct type, return to login page.
        return MaterialPageRoute(
          builder: (_) => ChooseLogInType(),
        );

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
