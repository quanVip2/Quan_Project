import 'package:flutter/material.dart';
import '../../features/library/data/models/playlist_model.dart';
import '../../features/library/data/repositories/playlist_repository.dart';
import '../../features/library/presentation/widgets/playlist_grid.dart';
import '../../features/library/presentation/widgets/library_category_chips.dart';
import '../widgets/avatar.dart';
import 'playlist_detail_page.dart';
import 'liked_music_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  final PlaylistRepository _playlistRepository = PlaylistRepository();
  List<PlaylistModel> playlists = [];
  bool isLoading = false;
  String selectedCategory = "Playlists";

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _playlistRepository.getPlaylistsByUserId(context, "current_user");
      setState(() {
        playlists = result;
      });
    } catch (e) {
      print('Error fetching playlists: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createNewPlaylist() async {
    try {
      await _playlistRepository.createPlaylist(context);
      fetchPlaylists();
    } catch (e) {
      print('Error creating playlist: $e');
    }
  }

  void onPlaylistTap(PlaylistModel playlist) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailPage(
          playlistId: playlist.id,
          playlistName: playlist.name,
          ownerName: playlist.userId, 
          imageUrl: null, 
          description: playlist.description,
        ),
      ),
    );
    
    if (result == 'deleted' || result == 'updated') {
      fetchPlaylists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                  Row(
                            children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        child: Text('Q', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Thư viện',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {},
                      ),
                          IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: createNewPlaylist,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chip filter
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChipWidget(label: 'Danh sách phát', selected: selectedCategory == 'Playlists', onTap: () => setState(() => selectedCategory = 'Playlists')),
                    const SizedBox(width: 8),
                    FilterChipWidget(label: 'Podcast', selected: selectedCategory == 'Podcast', onTap: () => setState(() => selectedCategory = 'Podcast')),
                    const SizedBox(width: 8),
                    FilterChipWidget(label: 'Nghệ sĩ', selected: selectedCategory == 'Nghệ sĩ', onTap: () => setState(() => selectedCategory = 'Nghệ sĩ')),
                  ],
                ),
              ),
            ),
            // Gần đây + sort icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.sort, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Grid các item
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        // Ví dụ: item yêu thích
                        LibraryGridItem(
                          icon: Icons.favorite,
                          color: Colors.purpleAccent,
                          title: 'Bài hát ưa thích',
                          subtitle: 'Danh sách phát',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LikedMusicPage(),
                              ),
                            );
                          },
                        ),
                        // Playlist từ API
                        ...playlists.map((playlist) => LibraryGridItem(
                              imageUrl: playlist.imageUrl,
                              icon: Icons.queue_music,
                              color: Colors.blueGrey,
                              title: playlist.name,
                              subtitle: playlist.description,
                              onTap: () => onPlaylistTap(playlist),
                            )),
                        // Nút thêm nghệ sĩ
                        LibraryGridItem(
                          icon: Icons.person_add,
                          color: Colors.grey[800],
                          title: 'Thêm nghệ sĩ',
                          subtitle: '',
                          onTap: () {},
                        ),
                        // Nút thêm podcast
                        LibraryGridItem(
                          icon: Icons.podcasts,
                          color: Colors.grey[800],
                          title: 'Thêm podcast và chương trình',
                          subtitle: '',
                          onTap: () {},
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const FilterChipWidget({super.key, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class LibraryGridItem extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final Color? color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const LibraryGridItem({
    super.key,
    this.icon,
    this.imageUrl,
    this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl!, width: 72, height: 72, fit: BoxFit.cover),
              )
            else if (icon != null)
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  color: color ?? Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 40),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
