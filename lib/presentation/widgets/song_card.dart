import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String artist;
  final VoidCallback? onTap;

  const SongCard({
    Key? key,
    required this.image,
    required this.title,
    required this.artist,
    this.onTap,
  }) : super(key: key);

  // Factory constructor để tạo từ URL
  factory SongCard.network({
    Key? key,
    required String imageUrl,
    required String title,
    required String artist,
    VoidCallback? onTap, required String description,
  }) {
    return SongCard(
      key: key,
      image: NetworkImage(imageUrl),
      title: title,
      artist: artist,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image(
                image: image,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(title, overflow: TextOverflow.ellipsis),
            Text(artist, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
