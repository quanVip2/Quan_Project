import 'package:flutter/material.dart';
import '../../features/music/data/models/album_model.dart';
import '../../features/music/data/repositories/album_repository.dart';

class AlbumDetailPage extends StatefulWidget {
  final int albumId;
  const AlbumDetailPage({super.key, required this.albumId});

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  AlbumModel? album;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchAlbum();
  }

  Future<void> fetchAlbum() async {
    try {
      print('AlbumDetailPage albumId: [32m[1m${widget.albumId}[0m');
      final repo = AlbumRepository();
      final result = await repo.getAlbumDetail(context, widget.albumId);
      setState(() {
        album = result;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi fetch album: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }
    if (album == null) {
      return Scaffold(
        body: Center(child: Text('Không tìm thấy album')),
      );
    }

    final musics = album!.musics ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Ảnh album lớn
          Container(
            height: 260,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                album!.linkUrlImageAlbum,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Album info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album!.albumTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "quanprovaion", // Thay bằng tên user nếu có
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.public, color: Colors.white38, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "32 phút", // Thay bằng thời gian thực nếu có
                      style: const TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(album!.linkUrlImageAlbum),
                      radius: 18,
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Danh sách bài hát
          ...musics.map((music) => ListTile(
                leading: music.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(music.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.music_note, color: Colors.white),
                title: Text(
                  music.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  music.authors.map((a) => a.name).join(', '),
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.more_vert, color: Colors.white),
                onTap: () {
                  // TODO: Chuyển sang trang phát nhạc
                },
              )),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Thư viện'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Premium'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // TODO: Xử lý chuyển tab
        },
      ),
    );
  }
}