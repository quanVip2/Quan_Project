import 'package:flutter/material.dart';
import 'package:untitled/core/theme/app_pallete.dart';

class AppTheme{
  static final lightTheme = ThemeData(
    primaryColor: Pallete.primary,
    scaffoldBackgroundColor: Pallete.lightBackground,
    brightness: Brightness.light,
    elevatedButtonTheme:  ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.primary,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        )
      )
    ),
    );


  static final darkTheme = ThemeData(
    primaryColor: Pallete.primary,
    scaffoldBackgroundColor: Pallete.darkBackground,
    brightness: Brightness.dark,
    elevatedButtonTheme:  ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.primary,
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            )
        )
    ),
  );

}