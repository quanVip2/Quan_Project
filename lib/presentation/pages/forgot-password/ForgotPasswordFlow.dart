import 'package:flutter/material.dart';
import 'forgot-password.dart';
import 'reset-password.dart';
import 'Verify_otp_screen.dart';

class ForgotPasswordFlow extends StatelessWidget {
  const ForgotPasswordFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/forgot-password',
      routes: {
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/otp-verification': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return VerifyOtpScreen(email: email);
        },
        '/reset-password': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          final email = args['email']!;
          final token = args['token']!;
          return ResetPasswordScreen(email: email, token: token);
        },
      },
    );
  }
}
