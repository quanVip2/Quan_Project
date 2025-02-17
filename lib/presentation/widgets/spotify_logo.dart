import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/image/spotify_logo.png',
      height: 96,
      width: 101,
      fit: BoxFit.contain,
    );
  }
}
