import 'package:flutter/material.dart';
import 'package:untitled/core/theme/chip_button.dart';

import '../widgets/avatar.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              ))),
          SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AvatarCircle(image: AssetImage('assets/image/album1.jpg')),
                              SizedBox(width: 10,),
                              Text("Thư viện"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 20,),
                              Icon(Icons.add)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      rowChips(),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Gần đây"),
                          Icon(Icons.list)
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  rowChips() {
    return Row(
      children: <Widget>[
        ChipButton(
          label: "Playlists",
          onChipClicked: () {},
        ),
        ChipButton(
          label: "Podcasts",
          onChipClicked: () {},
        ),
        ChipButton(
          label: "Albums",
          onChipClicked: () {},
        ),
        ChipButton(
          label: "Artists",
          onChipClicked: () {},
        ),
      ],
    );
  }
}
