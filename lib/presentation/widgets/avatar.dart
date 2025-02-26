import 'package:flutter/material.dart';

import 'drawer_view.dart';

class AvatarCircle extends StatelessWidget {
  final ImageProvider image;
  const AvatarCircle({super.key, required this.image, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Scaffold.of(context).openDrawer();
        //Đoạn này viết drawer
      } ,
      child: CircleAvatar(
        radius: 20,
        backgroundImage: image,
      ),
    );
  }
}
