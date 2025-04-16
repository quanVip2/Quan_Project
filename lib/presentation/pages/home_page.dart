import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/core/theme/chip_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/music/data/models/music.dart'; 
import 'package:untitled/features/bloc/auth_bloc.dart'; 
import 'package:untitled/features/bloc/auth_state.dart'; 
import 'package:untitled/presentation/widgets/drawer_view.dart';
import 'package:untitled/presentation/widgets/avatar.dart';
import 'package:untitled/presentation/widgets/album_card.dart';
import 'package:untitled/presentation/widgets/song_card.dart';
import 'package:untitled/presentation/pages/musicPlayer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); 

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
      final token = context.read<AuthBloc>().state is AuthAuthenticated
          ? (context.read<AuthBloc>().state as AuthAuthenticated).token
          : null;

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/home/paging/music'),
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Content-Type': 'application/json',
        },
      );

      print("🔥 Raw response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final musicList = jsonResponse['data']['musics'] as List;
        
        setState(() {
          musics = musicList.map((e) => MusicItem.fromJson(e)).toList();
        });
      } else {
        print("❌ Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
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
                  Colors.white.withAlpha((0.5 * 255).toInt()), // Alpha 128
                  Colors.white.withAlpha((0.1 * 255).toInt()), // Alpha 25
                  Colors.black.withAlpha((0 * 255).toInt()),   // Alpha 0
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
// NEW: Music Paging - Recently Played style
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text("Recently Played", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 220, // Chiều cao phù hợp với SongCard
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : musics.isEmpty
                            ? const Center(child: Text("No music found."))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: musics.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final music = musics[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: SongCard(
                                      imageUrl: music.imageUrl,
                                      title: music.title,
                                      artist: music.authors.map((a) => a.name).join(", "),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MusicPlayerPage(musicId: music.id),
                                          ),
                                        );
                                      },
                                    ),
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
class RowAlbumCard extends StatelessWidget{
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
            Image(image: image,
            height: 50,
            width: 50,
            fit: BoxFit.cover,),
            const SizedBox(width: 8,),
            Text(label)
          ],
        ),
      ),
    );
  }
}


