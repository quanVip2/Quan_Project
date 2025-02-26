import 'package:flutter/material.dart';
import 'package:untitled/presentation/widgets/avatar.dart';
import 'package:untitled/presentation/widgets/drawer_view.dart';
import 'package:untitled/presentation/widgets/search_card.dart';

import '../widgets/search_box.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerView(),
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
            )),
          ),
          SafeArea(child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AvatarCircle(image: AssetImage('assets/image/album1.jpg')),
                            SizedBox(width: 10,),
                            Text("Search"),
                          ],
                        ),
                        Icon(Icons.camera_alt_outlined)
                      ],
                    ),
                    SizedBox(height: 15,),
                    SearchBox(),
                    SizedBox(height: 20,),
                    Text("Duyệt tim tất cả"),
                    SizedBox(height: 15,),
                    SearchCard(),
                    SizedBox(height: 10,),
                    SearchCard(),
                    SizedBox(height: 10,),
                    SearchCard(),SizedBox(height: 10,),
                    SearchCard(),SizedBox(height: 10,),
                    SearchCard(),SizedBox(height: 10,),
                    SearchCard(),SizedBox(height: 10,),
                    SearchCard(),SizedBox(height: 10,),
                    SearchCard()

                  ],
                ),
              )
            ],

          ),)
        ],
      ),
    );
  }
}
