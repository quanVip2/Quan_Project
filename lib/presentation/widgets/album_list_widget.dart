import 'package:flutter/material.dart';
import '../../features/music/data/models/album_model.dart';

class AlbumListWidget extends StatelessWidget {
  final List<AlbumModel> albums;
  final Function(AlbumModel) onAlbumTap;

  const AlbumListWidget({
    super.key,
    required this.albums,
    required this.onAlbumTap,
  });

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return const Center(
        child: Text(
          'Không có album nào',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return GestureDetector(
          onTap: () => onAlbumTap(album),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album cover image
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      album.linkUrlImageAlbum,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.music_note,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Album title
              Text(
                album.albumTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Album artists
              Text(
                album.authors?.map((author) => author.name).join(', ') ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
} 