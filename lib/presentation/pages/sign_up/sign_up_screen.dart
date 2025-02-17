import 'package:flutter/material.dart';
import 'package:untitled/presentation/widgets/spotify_logo.dart';
//import 'package:spotify_clone/features/auth/presentation/widgets/sign_up_with.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            LogoWidget(),
            const SizedBox(height: 18),
            // Tiêu đề
            const Text(
              "Sign up to start\nlistening",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // "Continue with email"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/signup_email');
              },
              icon: const Icon(Icons.email, color: Colors.black),
              label: const Text(
                "Continue with email",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // "Continue with phone number"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                // Logic cho "Continue with phone number"
              },
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text("Continue with phone number"),
            ),
            const SizedBox(height: 16),
            // Nút "Continue with Google"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                // Logic cho "Continue with Google"
              },
              icon: const Icon(Icons.g_mobiledata, color: Colors.white),
              label: const Text("Continue with Google"),
            ),
            const SizedBox(height: 16),
            // Nút "Continue with Facebook"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                // Logic cho "Continue with Facebook"
              },
              icon: const Icon(Icons.facebook, color: Colors.blue),
              label: const Text("Continue with Facebook"),
            ),
            /*SignUpWith(
                icon: const Icon(Icons.facebook, color: Colors.white),
                label: "WIth"),*/
            const Spacer(),
            // TextButton cho "Already have an account? Log in"
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: RichText(
                text: const TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Log in",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
