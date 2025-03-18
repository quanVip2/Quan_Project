import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

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
    return Scaffold(body: Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          /// Ảnh nền
          Column(
            children: [
              Image.asset(
                "assets/image/pre_ima.jpg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 200,
                fit: BoxFit.cover,

              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage('assets/image/spotify_logo.png'),
                          width: 30,
                          height: 30,),
                        SizedBox(width: 20,),
                        Text('Premium', style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),)
                      ],
                    ),
                    Text('Nghe không giới hạn. Dùng thử Premium Individual trong 3 tháng với giá 50.000₫ trên Spotify.',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Roboto'),)
                  ],
                ),)
            ],
          ),

          /// Lớp gradient đè lên ảnh
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width - 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ]),
      ),
      Container(
        child: Column(
          children: [
          ],
        ),
      )
    ]));
  }
}
