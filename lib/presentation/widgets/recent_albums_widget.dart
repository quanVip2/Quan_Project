import 'package:flutter/material.dart';
import '../../features/music/data/models/album_model.dart';
import '../../features/music/data/repositories/album_repository.dart';
import '../pages/album_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecentAlbumsWidget extends StatelessWidget {
  final List<RecentAlbum> albums;
  final Function(RecentAlbum)? onAlbumTap;

  const RecentAlbumsWidget({
    super.key,
    required this.albums,
    this.onAlbumTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: albums.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final album = albums[index];
          return GestureDetector(
            onTap: () {
              if (onAlbumTap != null) {
                onAlbumTap!(album);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumDetailPage(albumId: album.id),
                  ),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: album.imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey[800],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 150,
                  child: Text(
                    album.albumTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    album.nation,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}