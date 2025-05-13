import 'package:flutter/material.dart';

import 'app_pallete.dart';

class ButtonLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextStyle? style;

  const ButtonLarge({super.key, required this.text, this.color, this.style});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.white,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Text(
            text,
            style: style ?? Pallete.textApp(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
