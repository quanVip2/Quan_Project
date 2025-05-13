import 'package:flutter/material.dart';
import '../widgets/spotify_logo.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Spotify
                    LogoWidget(),
                    SizedBox(height: 18),
                    // Tiêu đề
                    Text(
                      "Millions of songs.\nFree on Spotify.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Nút "Sign up for free"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                "Sign up for free",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nút "Log in"
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                "Log in",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
