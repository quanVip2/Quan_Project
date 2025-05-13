import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/bloc/auth_bloc.dart';
import '../../features/bloc/auth_state.dart';
import 'musicPlayer_page.dart';
import '../../features/library/data/repositories/playlist_repository.dart';

class LikedMusicPage extends StatefulWidget {
  const LikedMusicPage({super.key});

  @override
  State<LikedMusicPage> createState() => _LikedMusicPageState();
}

class _LikedMusicPageState extends State<LikedMusicPage> {
  bool isLoading = true;
  String? error;
  List<Map<String, dynamic>> likedSongs = [];

  @override
  void initState() {
    super.initState();
    fetchLikedSongs();
  }

  Future<void> fetchLikedSongs() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final repo = PlaylistRepository();
      final data = await repo.getLikedMusics(context);
      setState(() {
        likedSongs = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Lỗi: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Bài hát ưa thích', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : likedSongs.isEmpty
                  ? const Center(child: Text('Chưa có bài hát yêu thích nào', style: TextStyle(color: Colors.white70)))
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // Ảnh playlist lớn phía trên
                        Container(
                          height: 220,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: likedSongs.isNotEmpty && likedSongs[0]['imageUrl'] != null
                                ? Image.network(likedSongs[0]['imageUrl'], fit: BoxFit.cover)
                                : Container(color: Colors.grey[800]),
                          ),
                        ),
                        // Info playlist
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bài hát ưa thích',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                                    backgroundImage: likedSongs.isNotEmpty && likedSongs[0]['imageUrl'] != null
                                        ? NetworkImage(likedSongs[0]['imageUrl'])
                                        : null,
                                    radius: 18,
                                    backgroundColor: Colors.grey[800],
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
                        ...likedSongs.map((song) => ListTile(
                              leading: song['imageUrl'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(song['imageUrl'], width: 48, height: 48, fit: BoxFit.cover),
                                    )
                                  : Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.music_note, color: Colors.white),
                                    ),
                              title: Text(song['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(song['artist'] ?? '', style: const TextStyle(color: Colors.white70)),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.grey[900],
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    builder: (ctx) {
                                      return SafeArea(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.delete, color: Colors.red),
                                              title: const Text('Xóa khỏi yêu thích', style: TextStyle(color: Colors.red)),
                                              onTap: () async {
                                                Navigator.of(ctx).pop();
                                                final musicId = song['musicId'] ?? song['id'];
                                                int? id;
                                                if (musicId is int) {
                                                  id = musicId;
                                                } else if (musicId is String) {
                                                  id = int.tryParse(musicId);
                                                }
                                                if (id == null) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Bài hát không hợp lệ!')),
                                                  );
                                                  return;
                                                }
                                                try {
                                                  final repo = PlaylistRepository();
                                                  await repo.deleteMusicFromLikeMusic(context, id);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Đã xóa khỏi yêu thích'), backgroundColor: Colors.green),
                                                  );
                                                  fetchLikedSongs();
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              onTap: () {
                                final musicId = song['musicId'] ?? song['id'];
                                int? id;
                                if (musicId is int) {
                                  id = musicId;
                                } else if (musicId is String) {
                                  id = int.tryParse(musicId);
                                }
                                if (id == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Bài hát không hợp lệ!')),
                                  );
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MusicPlayerPage(musicId: id!),
                                  ),
                                );
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