import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/core/theme/chip_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/music/data/models/music.dart'; 
import 'package:untitled/features/bloc/auth_bloc.dart'; 
import 'package:untitled/features/bloc/auth_state.dart';
import 'package:untitled/presentation/pages/album_detail_page.dart'; 
import 'package:untitled/presentation/widgets/drawer_view.dart';
import 'package:untitled/presentation/widgets/avatar.dart';
import 'package:untitled/presentation/widgets/album_card.dart';
import 'package:untitled/presentation/widgets/song_card.dart';
import 'package:untitled/presentation/pages/musicPlayer_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:untitled/features/music/data/models/music_detail_model.dart';
import 'package:untitled/features/music/data/repositories/music_service.dart';
import 'package:untitled/features/music/data/repositories/music_pading.dart';
import '../../features/music/data/models/music.dart';
import 'package:flutter/material.dart';
import '../../presentation/widgets/album_list_widget.dart';
import '../../features/music/data/models/album_model.dart';
import '../../features/music/data/repositories/album_repository.dart';
import '../../presentation/widgets/recent_albums_widget.dart';

class HomePage extends StatefulWidget {
  final Function(MusicDetail)? onTrackSelected; // 👈 thêm dòng này
  const HomePage({super.key, this.onTrackSelected}); 

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<MusicItem> musics = [];
  bool isLoading = false;
  MusicDetail? _currentTrack;
  final AudioPlayer _player = AudioPlayer();
  late Future<List<AlbumModel>> albumsFuture;

  @override
  void initState() {
    super.initState();
    fetchMusicList();
    albumsFuture = fetchAlbums();
  }

  Future<void> fetchMusicList() async {
    setState(() => isLoading = true);
    try {
      final pagingService = MusicPagingService();
      final fetchedMusics = await pagingService.fetchPagedMusics(context);
      setState(() {
        musics = fetchedMusics;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<List<AlbumModel>> fetchAlbums() async {
    final repo = AlbumRepository();
    return await repo.getAlbums(context);
  }

  void playMusic(MusicItem item) async {
    final musicService = MusicService();
    try {
      final detail = await musicService.fetchMusicDetail(context, item.id);

      // 👉 Mở trang phát nhạc trước
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MusicPlayerPage(musicId: detail.id),
        ),
      );

      // 👉 Sau khi trở lại, gọi callback để hiển thị mini player
      if (widget.onTrackSelected != null) {
        widget.onTrackSelected!(detail);
      } else {
        setState(() => _currentTrack = detail);
      }
    } catch (e) {
      debugPrint('Lỗi khi chuyển sang trang phát nhạc: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerView(),
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
                  Colors.white.withAlpha((0.5 * 255).toInt()),
                  Colors.white.withAlpha((0.1 * 255).toInt()),
                  Colors.black.withAlpha((0 * 255).toInt()),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AvatarCircle(image: AssetImage('assets/image/album1.jpg')),
                          rowChips(),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Recently Played" , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 16),
                            Icon(Icons.settings),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Widget Recently Played
                  FutureBuilder<List<RecentMusic>>(
                    future: MusicService().fetchRecentlyPlayed(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: \\${snapshot.error}', style: TextStyle(color: Colors.red)));
                      }
                      final musics = snapshot.data ?? [];
                      if (musics.isEmpty) {
                        return const Center(child: Text('Chưa có bài hát nào', style: TextStyle(color: Colors.white70)));
                      }
                      return SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: musics.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final song = musics[index];
                            return GestureDetector(
                              onTap: () {
                                if (song.id != 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MusicPlayerPage(musicId: song.id),
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                children: [
                                  song.imageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(song.imageUrl, width: 150, height: 150, fit: BoxFit.cover),
                                        )
                                      : Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.music_note, color: Colors.white),
                                        ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 64,
                                    child: Text(
                                      song.title,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 64,
                                    child: Text(
                                      song.authors is List
                                          ? (song.authors as List).map((a) => a.name).join(", ")
                                          : song.authors.toString(),
                                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tuyển tập hàng đầu của bạn ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 16),
                            Icon(Icons.settings),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : musics.isEmpty
                            ? const Center(child: Text("No music found."))
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: musics.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final song = musics[index];
                                  return SongCard(
                                    imageUrl: song.imageUrl,
                                    title: song.title,
                                    artist: song.authors is List ? (song.authors as List).map((a) => a.name).join(', ') : song.authors.toString(),
                                    onTap: () {
                                      if (song.id != 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MusicPlayerPage(musicId: song.id),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phổ biến nhất" , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 16),
                            Icon(Icons.settings),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mới Phát Hành" , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 16),
                            Icon(Icons.settings),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Dành cho fan của Kendrick Lamar" , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 16),
                            Icon(Icons.settings),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Album đã nghe gần đây", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 16),
                            Icon(Icons.settings),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<RecentAlbum>>(
                    future: AlbumRepository().fetchRecentlyPlayedAlbums(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                      }
                      final albums = snapshot.data ?? [];
                      if (albums.isEmpty) {
                        return const Center(child: Text('Chưa có album nào', style: TextStyle(color: Colors.white70)));
                      }
                      return RecentAlbumsWidget(
                        albums: albums,
                        onAlbumTap: (album) {
                          print('Album id: ${album.id}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumDetailPage(albumId: album.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (_currentTrack != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.black87,
                child: Row(
                  children: [
                    Image.network(
                      _currentTrack!.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_currentTrack!.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(
                            _currentTrack!.authors is List
                                ? (_currentTrack!.authors as List).map((a) => a.name).join(", ")
                                : _currentTrack!.authors.toString(),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(_player.playing ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _player.playing ? _player.pause() : _player.play();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

rowChips() {
  return Row(
    children: <Widget>[
      ChipButton(label: "Tất cả", onChipClicked: () {}),
      ChipButton(label: "Nhạc", onChipClicked: () {}),
      ChipButton(label: "Podcasts", onChipClicked: () {}),
    ],
  );
}

class RowAlbumCard extends StatelessWidget {
  final AssetImage image;
  final String label;

  const RowAlbumCard({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Image(image: image, height: 50, width: 50, fit: BoxFit.cover),
            const SizedBox(width: 8),
            Text(label)
          ],
        ),
      ),
    );
  }
}
