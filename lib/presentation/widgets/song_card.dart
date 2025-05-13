import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;
  final VoidCallback? onTap;

  const SongCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child:Image.network(
                      imageUrl,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 140,
                          width: 140,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          width: 140,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        );
                      },
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
