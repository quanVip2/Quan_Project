import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.music_note, // Thay bằng logo cụ thể nếu có
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 20),
            // Tiêu đề
            const Text(
              "Log in to\nSpotify",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // Nút "Continue with email"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/login_email'); // Điều hướng tới LoginEmailScreen
              },
              icon: const Icon(Icons.email, color: Colors.black),
              label: const Text(
                "Continue with email",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // Nút "Continue with phone number"
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
            const Spacer(),
            // TextButton cho "Don't have an account? Sign up"
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/signup'); // Điều hướng tới màn hình đăng ký
              },
              child: RichText(
                text: const TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign up",
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
