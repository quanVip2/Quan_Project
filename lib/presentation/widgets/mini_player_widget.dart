import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:untitled/features/music/data/models/music_detail_model.dart';
import 'package:untitled/presentation/pages/musicPlayer_page.dart';
import 'package:untitled/features/music/data/repositories/music_player_controller.dart';

class MiniPlayerWidget extends StatefulWidget {
  final MusicDetail currentMusic;
  final Function(MusicDetail) onMusicChanged;

  const MiniPlayerWidget({
    super.key,
    required this.currentMusic,
    required this.onMusicChanged,
  });

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  late MusicDetail music;
  final controller = MusicPlayerController.instance;

  @override
  void initState() {
    super.initState();
    music = widget.currentMusic;
    controller.currentTrackNotifier.addListener(_onTrackChanged);
    controller.getCurrentMusic().then((m) {
      if (m != null && mounted) {
        setState(() => music = m);
      }
    });
  }

  void _onTrackChanged() {
    final current = controller.currentTrackNotifier.value;
    if (current != null && mounted) {
      setState(() => music = current);
      widget.onMusicChanged(current);
    }
  }

  @override
  void dispose() {
    controller.currentTrackNotifier.removeListener(_onTrackChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MusicPlayerPage(musicId: music.id),
            ),
          ).then((_) async {
            final current = await controller.getCurrentMusic();
            if (current != null && mounted) {
              setState(() => music = current);
              widget.onMusicChanged(current);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 92,
          decoration: const BoxDecoration(
            color: Colors.black87,
            border: Border(top: BorderSide(color: Colors.white12)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: music.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      music.authors.map((e) => e.name).join(', '),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    StreamBuilder<Duration>(
                      stream: controller.player.positionStream,
                      builder: (context, posSnapshot) {
                        final position = posSnapshot.data ?? Duration.zero;
                        return StreamBuilder<Duration?>(
                          stream: controller.player.durationStream,
                          builder: (context, durSnapshot) {
                            final duration = durSnapshot.data ?? Duration.zero;
                            final total = duration.inSeconds;
                            final current = position.inSeconds;

                            if (total == 0) return const SizedBox.shrink();

                            return SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white30,
                                thumbColor: Colors.white,
                                overlayColor: Colors.white24,
                                trackHeight: 2,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                              ),
                              child: Slider(
                                min: 0,
                                max: total.toDouble(),
                                value: current.clamp(0, total).toDouble(),
                                onChanged: (value) {
                                  controller.player.seek(Duration(seconds: value.toInt()));
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: () async {
                      await controller.playRewindMusic(context, widget.onMusicChanged);
                      final updatedMusic = await controller.getCurrentMusic();
                      if (mounted && updatedMusic != null) {
                        setState(() => music = updatedMusic);
                      }
                    },
                    splashRadius: 20,
                  ),
                  StreamBuilder<PlayerState>(
                    stream: controller.player.playerStateStream,
                    builder: (context, snapshot) {
                      final playing = snapshot.data?.playing ?? false;
                      return IconButton(
                        icon: Icon(
                          playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          playing ? controller.player.pause() : controller.player.play();
                        },
                        splashRadius: 24,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: () async {
                      await controller.playNextMusic(context, widget.onMusicChanged);
                      final updatedMusic = await controller.getCurrentMusic();
                      if (mounted && updatedMusic != null) {
                        setState(() => music = updatedMusic);
                      }
                    },
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}