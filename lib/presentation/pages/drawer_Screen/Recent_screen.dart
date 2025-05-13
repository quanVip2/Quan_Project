import 'package:flutter/material.dart';
import '../../../features/music/data/models/music.dart';
import '../../../features/music/data/repositories/music_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/bloc/auth_bloc.dart';
import '../../../features/bloc/auth_state.dart';
import '../musicPlayer_page.dart';

class RecentPlaysPage extends StatefulWidget {
  const RecentPlaysPage({super.key});

  @override
  State<RecentPlaysPage> createState() => _RecentPlaysPageState();
}

class _RecentPlaysPageState extends State<RecentPlaysPage> {
  bool isLoading = true;
  String? error;
  List<RecentMusic> musics = [];

  @override
  void initState() {
    super.initState();
    fetchRecentMusics();
  }

  Future<void> fetchRecentMusics() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final result = await MusicService().fetchRecentlyPlayed(context);
      setState(() {
        musics = result;
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Nhạc đã nghe gần đây", style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : musics.isEmpty
                  ? const Center(child: Text('Chưa có bài hát nào', style: TextStyle(color: Colors.white70)))
                  : ListView.separated(
                      itemCount: musics.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
                      itemBuilder: (context, index) {
                        final song = musics[index];
                        return ListTile(
                          leading: song.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(song.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
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
                          title: Text(song.title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(song.authors, style: const TextStyle(color: Colors.white70)),
                          onTap: () {
                            // Nếu có id thì mở MusicPlayerPage, nếu không thì bỏ qua
                            // (API recently played hiện tại không trả id, nếu có thì truyền vào đây)
                          },
                        );
                      },
                    ),
    );
  }
}
