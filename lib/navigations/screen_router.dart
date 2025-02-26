import 'package:flutter/material.dart';
import 'package:untitled/navigations/splash_screen.dart';
import 'package:untitled/presentation/pages/start_screen.dart';
import 'package:untitled/presentation/pages/sign_up/sign_up_screen.dart';
import 'package:untitled/presentation/pages/login/login_screen.dart';
import 'package:untitled/presentation/pages/login/login_email_screen.dart';
import 'package:untitled/presentation/pages/sign_up/step_email.dart';
import 'package:untitled/presentation/pages/sign_up/step_password.dart';
import 'package:untitled/presentation/pages/sign_up/step_dob.dart';
import 'package:untitled/presentation/pages/sign_up/step_gender.dart';
import 'package:untitled/presentation/pages/sign_up/step_name.dart';
import '../navigations/tabbar.dart';

class AppRouter {
  static const String start = '/';
  static const String splash = '/splash';
  static const String signUp = '/signup';
  static const String login = '/login';
  static const String loginEmail = '/login_email';
  static const String signUpEmail = '/signup_email';
  static const String signUpPassword = '/signup_password';
  static const String signUpDob = '/signup_dob';
  static const String signUpGender = '/signup_gender';
  static const String signUpName = '/signup_name';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case start:
        return MaterialPageRoute(builder: (_) => const StartScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case loginEmail:
        return MaterialPageRoute(builder: (_) => const LoginEmailScreen());
      case signUpEmail:
        return MaterialPageRoute(builder: (_) => const SignUpEmailScreen());
      case signUpPassword:
        return MaterialPageRoute(builder: (_) => const SignUpPasswordScreen());
      case signUpDob:
        return MaterialPageRoute(builder: (_) => const SignUpDateOfBirthScreen());
      case signUpGender:
        return MaterialPageRoute(builder: (_) => const SignUpGenderScreen());
      case signUpName:
        return MaterialPageRoute(builder: (_) => const SignUpNameScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const Tabbar());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Không tìm thấy trang!')),
          ),
        );
    }
  }
}
