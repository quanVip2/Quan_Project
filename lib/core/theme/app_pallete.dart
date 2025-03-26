import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pallete {

  static const primary = Color(0xFF48C73F);
  static const lightBackground = Color(0xFFFFFFFF);
  static const darkBackground = Color(0xFF1A1B1D);
  static const grey = Color(0xFF61646E);
  static const darkGrey = Color(0xFF34353B);
  static Color get randomColor =>  Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1.0,
    );

  static TextStyle textApp({double fontSize = 16 , FontWeight fontWeight = FontWeight.bold, Color? color, TextDecoration? decoration}){
    return GoogleFonts.getFont('Montserrat',
    fontWeight: fontWeight,
    fontSize: fontSize,
    decoration: decoration,
    color: color ?? Colors.white,);
  }
}
