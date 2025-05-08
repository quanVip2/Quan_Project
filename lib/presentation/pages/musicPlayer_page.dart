import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../features/music/data/models/music_detail_model.dart';
import '../../features/music/data/models/duration_state.dart';
import '../../features/music/data/repositories/music_player_controller.dart';
import '../../features/music/data/repositories/music_service.dart';

class MusicPlayerPage extends StatefulWidget {
  final int musicId;
  const MusicPlayerPage({super.key, required this.musicId});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool isLoading = true;
  MusicDetail? music;

  final controller = MusicPlayerController.instance;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void didUpdateWidget(covariant MusicPlayerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.musicId != oldWidget.musicId) {
      _loadMusic(); // Gọi lại nếu ID thay đổi
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMusic();

    controller.setOnMusicChanged((MusicDetail newMusic) {
      if (!mounted) return;
      setState(() {
        music = newMusic;
      });
    });

    _playerStateSubscription =
        controller.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        controller.playNextMusic(context, (newMusic) {
          if (!mounted) return;
          setState(() {
            music = newMusic;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    controller.setOnMusicChanged(null); // Clear callback
    super.dispose();
  }

  Future<void> _loadMusic() async {
    try {
      final result =
          await MusicService().fetchMusicDetail(context, widget.musicId);
      final current = controller.currentTrack;

      if (!mounted) return;
      setState(() {
        music = result;
        isLoading = false;
      });

      if (current == null || current.id != result.id) {
        await controller.setCurrentTrack(result);
      }
    } catch (e) {
      debugPrint('Lỗi fetch music: $e');
    }
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration, DurationState>(
        controller.player.positionStream,
        controller.player.durationStream.whereType<Duration>(),
        (position, duration) => DurationState(position, duration),
      );

  @override
  Widget build(BuildContext context) {
    if (isLoading || music == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Text(music!.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl: music!.imageUrl,
            placeholder: (_, __) => const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) =>
                const Icon(Icons.error, color: Colors.white),
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  music!.title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  music!.authors.map((a) => a.name).join(', '),
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  music!.categories.map((c) => c.name).join(', '),
                  style: const TextStyle(fontSize: 14, color: Colors.white54),
                ),
                const SizedBox(height: 12),
                Text(
                  music!.description,
                  style: const TextStyle(color: Colors.white60),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<DurationState>(
            stream: _durationStateStream,
            builder: (context, snapshot) {
              final durationState = snapshot.data;
              final position = durationState?.position ?? Duration.zero;
              final total = durationState?.total ?? Duration.zero;

              return Column(
                children: [
                  Slider(
                    activeColor: Colors.green,
                    inactiveColor: Colors.white24,
                    min: 0,
                    max: total.inSeconds.toDouble(),
                    value: position.inSeconds
                        .clamp(0, total.inSeconds)
                        .toDouble(),
                    onChanged: (value) {
                      controller.player
                          .seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position),
                            style:
                                const TextStyle(color: Colors.white70)),
                        Text(_formatDuration(total),
                            style:
                                const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 40,
                icon:
                    const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  controller.playRewindMusic(context, (newMusic) {
                    setState(() {
                      music = newMusic;
                    });
                  });
                },
              ),
              StreamBuilder<PlayerState>(
                stream: controller.player.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return IconButton(
                    iconSize: 72,
                    color: Colors.white,
                    icon: Icon(playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill),
                    onPressed: () {
                      if (playing) {
                        controller.pause();
                      } else {
                        controller.resume();
                      }
                    },
                  );
                },
              ),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  controller.playNextMusic(context, (newMusic) {
                    setState(() {
                      music = newMusic;
                    });
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Thời lượng: ${_formatDuration(Duration(seconds: music!.broadcastTime))}',
            style: const TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}