import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  final ImageProvider image;
  const PremiumPage({super.key, required this.image});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PremiumPageState();
  }
}

class PremiumPageState extends State<PremiumPage> {
  double imageOpacity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: imageOpacity.clamp(0, 1.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.5),
              offset: Offset(0, 20),
              blurRadius: 32,
              spreadRadius: 16,
            )
          ],
        ),
                  child: Image(
                    image: widget.image,
                    fit: BoxFit.fill,
                  ),
                )
                )],
            ),
          )
        ],
      ),
    );
  }
}
