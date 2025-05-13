import 'package:flutter/material.dart';
import 'package:untitled/core/theme/app_pallete.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            CardGenre(label: 'Nhạc', image: AssetImage("assets/image/album5.jpg"),),
            CardGenre(label: "Podcasts", image: AssetImage("assets/image/album1.jpg"),),
          ],
        ),
        Row(
          children: [
            CardGenre(label: 'Nhạc', image: AssetImage("assets/image/album4.jpg"),),
            CardGenre(label: "Podcasts", image: AssetImage("assets/image/album6.jpg"),),
          ],
        ),
        Row(
          children: [
            CardGenre(label: 'Nhạc', image: AssetImage("assets/image/album2.jpg"),),
            CardGenre(label: "Podcasts", image: AssetImage("assets/image/album7.jpg"),),
          ],
        ),
        Row(
          children: [
            CardGenre(label: 'Nhạc', image: AssetImage("assets/image/album5.jpg"),),
            CardGenre(label: "Podcasts", image: AssetImage("assets/image/album3.jpg"),),
          ],
        ),
      ],
    );
  }
}


    


class CardGenre extends StatelessWidget {
  final String label;
  final AssetImage image;

  const CardGenre({super.key, required this.label, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 180,
        height: 100,
        decoration: BoxDecoration(
          color: Pallete.randomColor,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(label),
              ],
            ),
            Transform.rotate(
                angle: 0.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image(image: image, width: 70, height: 70, fit: BoxFit.cover),
              ),

            )
          ],
        ),
      ),
    );
  }
}
