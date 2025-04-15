import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/core/theme/chip_button.dart';
import 'package:untitled/presentation/widgets/drawer_view.dart';
import 'package:untitled/presentation/widgets/avatar.dart';
import '../widgets/album_card.dart';
import '../widgets/song_card.dart';
import '../../features/music/data/models/music.dart'; // Import model mới bạn đã viết

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<MusicItem> musics = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMusicList();
  }

  Future<void> fetchMusicList() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/paging/music'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final musicListResponse = MusicListResponse.fromJson(jsonResponse);
        setState(() {
          musics = musicListResponse.data.musics;
        });
      } else {
        print("Error fetching music: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
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
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.1),
                  Colors.black.withOpacity(0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Recently Played"),
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
                  // ... các mục Recently Played và Recommend giữ nguyên ...

                  // NEW: Music Paging
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Music List (from API)"),
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : musics.isEmpty
                          ? const Center(child: Text("No music found."))
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: musics.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                                itemBuilder: (context, index) {
                                  final music = musics[index];
                                  return SongCard(
                                    image: NetworkImage(music.imageUrl),
                                    title: music.title,
                                    artist: music.authors.map((a) => a.name).join(", "),
                                    onTap: () {
                                      // Ví dụ khi click vào bài hát
                                      Navigator.push(...);},
                                  );
                                },
                              ),
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
            Text(label),
          ],
        ),
      ),
    );
  }
}
