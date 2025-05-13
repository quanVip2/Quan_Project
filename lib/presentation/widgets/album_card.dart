import 'package:flutter/material.dart';

import '../pages/album_view.dart';

class AlbumCard extends StatelessWidget{
  final ImageProvider image;
  final String label;
  final double size;
  // final Function onTap;

  const AlbumCard({super.key, required this.image, required this.label, this.size = 120,   });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumView(
              image: image,
            ),
          ),
        );
      },
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: image,
              width: size,
              height: size,
            ),
            const SizedBox(height: 10),
            Text(label),
          ],
        ),
    );
  }

}