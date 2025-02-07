import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.1),
                  Colors.black.withOpacity(0),

                ],

              )
            ),
          ),
          // Scrollable content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recently Played",
                          ),
                          Row(
                            children: [
                              Icon(Icons.history),
                              SizedBox(width: 16),
                              Icon(Icons.settings),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          AlbumCard(
                            image: AssetImage("assets/image/album1.jpg"),
                            label: "Best Mode",
                          ),
                          SizedBox(width: 20,),
                          AlbumCard(
                            image: AssetImage("assets/image/album2.jpg"),
                            label: "Best Mode",
                          ),
                          SizedBox(width: 20,),
                          AlbumCard(
                            image: AssetImage("assets/image/album3.jpg"),
                            label: "Best Mode",
                          ),
                          SizedBox(width: 20,),
                          AlbumCard(
                            image: AssetImage("assets/image/album4.jpg"),
                            label: "Best Mode",
                          ),
                          SizedBox(width: 20,),
                          AlbumCard(
                            image: AssetImage("assets/image/album5.jpg"),
                            label: "Best Mode",
                          ),
                        ],
                      ),
                      ),

                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}

class AlbumCard extends StatelessWidget{
  final ImageProvider image;
  final String label;
  final double size;
  // final Function onTap;

  const AlbumCard({Key? key, required this.image, required this.label, this.size = 120,   }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: image,
          width: size,
          height: size,
        ),
        SizedBox(height: 10),
        Text(label),
      ],
    );
  }

}



