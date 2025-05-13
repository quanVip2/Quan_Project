import 'package:flutter/material.dart';
import '../../data/models/playlist_model.dart';

class PlaylistGrid extends StatelessWidget {
  final List<PlaylistModel> playlists;
  final VoidCallback onCreatePlaylist;
  final Function(PlaylistModel) onPlaylistTap;

  const PlaylistGrid({
    super.key,
    required this.playlists,
    required this.onCreatePlaylist,
    required this.onPlaylistTap,
  });

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Chưa có playlist nào"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onCreatePlaylist,
              child: const Text("Tạo playlist mới"),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return GestureDetector(
          onTap: () => onPlaylistTap(playlist),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.playlist_play, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    playlist.name,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 