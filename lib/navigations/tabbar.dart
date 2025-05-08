import 'package:flutter/material.dart';
import 'package:untitled/features/music/data/repositories/music_rewind.dart';
import 'package:untitled/presentation/pages/home_page.dart';
import 'package:untitled/presentation/pages/search_page.dart';
import 'package:untitled/presentation/pages/library_page.dart';
import 'package:untitled/presentation/pages/premium_page.dart';
import 'package:untitled/presentation/widgets/mini_player_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:untitled/features/music/data/models/music_detail_model.dart';
import 'package:untitled/features/music/data/repositories/music_player_controller.dart';
import 'package:untitled/features/music/data/repositories/music_next.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return TabbarState();
  }
}

class TabbarState extends State<Tabbar> {
  int _selectedTab = 0;
  final MusicPlayerController _controller = MusicPlayerController.instance;
  MusicDetail? _currentTrack;

  @override
  void initState() {
    super.initState();
  }

  void _setCurrentTrack(MusicDetail track) async {
    await _controller.setCurrentTrack(track);
  }

  Future<void> _playNext() async {
    await _controller.playNextMusic(context, (newMusic) {
      setState(() {
        _currentTrack = newMusic;
      });
    });
  }

  Future<void> _playRewind() async {
    await _controller.playRewindMusic(context, (newMusic) {
      setState(() {
        _currentTrack = newMusic;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              HomePage(onTrackSelected: _setCurrentTrack),
              const SearchPage(),
              const LibraryPage(),
              const PremiumPage(),
            ],
          ),
        ),
        ValueListenableBuilder<MusicDetail?>(
          valueListenable: _controller.currentTrackNotifier,
          builder: (context, currentTrack, _) {
            if (currentTrack != null) {
              return SafeArea(
                bottom: false,
                child: MiniPlayerWidget(
                  currentMusic: currentTrack,
                  onMusicChanged: (newMusic) {
                    _controller.setCurrentTrack(newMusic);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (index) {
        setState(() {
          _selectedTab = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Tìm kiếm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music_outlined),
          label: 'Thư viện',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_center_outlined),
          label: 'Premium',
        ),
      ],
    ),
  );
}

  Widget renderView(int tabIndex, Widget page) {
    if (tabIndex == 0) {
      return IgnorePointer(
        ignoring: _selectedTab != tabIndex,
        child: Opacity(
          opacity: _selectedTab == tabIndex ? 1 : 0,
          child: HomePage(
            onTrackSelected: _setCurrentTrack,
          ),
        ),
      );
    }
    return IgnorePointer(
      ignoring: _selectedTab != tabIndex,
      child: Opacity(
        opacity: _selectedTab == tabIndex ? 1 : 0,
        child: page,
      ),
    );
  }
}
