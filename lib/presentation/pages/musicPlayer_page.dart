import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rxdart/rxdart.dart';
import '../../features/music/data/repositories/music_service.dart';
import '../../features/music/data/models/music_detail_model.dart';

class MusicPlayerPage extends StatefulWidget {
  final int musicId;
  const MusicPlayerPage({super.key, required this.musicId});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final _player = AudioPlayer();
  bool isLoading = true;
  MusicDetail? music;

  @override
  void initState() {
    super.initState();
    _loadMusic();
  }

  Future<void> _loadMusic() async {
    try {
      final result = await MusicService().fetchMusicDetail(widget.musicId);
      setState(() {
        music = result;
        isLoading = false;
      });
      await _player.setUrl(result.linkUrlMusic);
    } catch (e) {
      debugPrint('Lỗi fetch music: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration, DurationState>(
        _player.positionStream,
        _player.durationStream.whereType<Duration>(),
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
        title: Text(music!.title, style: const TextStyle(color: Colors.white)),
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
            errorWidget: (_, __, ___) => const Icon(Icons.error, color: Colors.white),
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
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
                    value: position.inSeconds.clamp(0, total.inSeconds).toDouble(),
                    onChanged: (value) {
                      _player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position), style: const TextStyle(color: Colors.white70)),
                        Text(_formatDuration(total), style: const TextStyle(color: Colors.white70)),
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
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  // TODO: handle previous
                },
              ),
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  return IconButton(
                    iconSize: 72,
                    color: Colors.white,
                    icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_fill),
                    onPressed: () {
                      if (playing) {
                        _player.pause();
                      } else {
                        _player.play();
                      }
                    },
                  );
                },
              ),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  // TODO: handle next
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

class DurationState {
  final Duration position;
  final Duration total;
  DurationState(this.position, this.total);
}
