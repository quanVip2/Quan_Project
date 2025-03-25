import 'package:flutter/material.dart';

import 'app_pallete.dart';

class ButtonLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextStyle? style;

  ButtonLarge({super.key, required this.text, this.color, this.style});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            text,
            style: style ?? Pallete.textApp(fontSize: 15),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.white,
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ),
    );
  }
}
